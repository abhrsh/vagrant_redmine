#
# Cookbook Name:: redmine
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "mysql"

# Get Redmine
git "/opt/redmine" do
  repository "https://github.com/redmine/redmine.git"
  reference "2.3-stable"
  action :sync
end

# Setting Redmine
template "/opt/redmine/Gemfile.local" do
  source "Gemfile.local.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

template "/opt/redmine/config/unicorn.rb" do
  source "unicorn.rb.erb"
  owner "root"
  group "root"
  mode "0755"
  action :create
end

template "/opt/redmine/config/database.yml" do
  source "database.yml.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

# Install Redmine
execute "Install Redmine" do
  cwd "/opt/redmine"
  command <<-EOS
    bundle install --path vendor/bundle --without development test rmagick postgresql sqlite
    mkdir public/plugin_assets
    chown -R vagrant:vagrant files log tmp public/plugin_assets
    chmod -R 755 files log tmp public/plugin_assets
  EOS
  creates "/opt/redmine/public/plugin_assets"
end

# Initialize database for Redmine
execute "Create database for Redmine" do
  command <<-EOS
    /usr/bin/mysql -u root -ppass <<SQL
      create database redmine character set utf8;
      create user 'redmine'@'localhost' identified by 'redmine';
      grant all privileges on redmine.* to 'redmine'@'localhost';
SQL
  EOS
  action :run
  not_if "/usr/bin/mysql -u root -ppass redmine -e 'show databases;'"
end

execute "Load default data for Redmine" do
  cwd "/opt/redmine"
  command <<-EOS
    rake generate_secret_token
    RAILS_ENV=production rake db:migrate
    RAILS_ENV=production REDMINE_LANG=ja rake redmine:load_default_data
  EOS
  action :run
  not_if {File.exists?("/opt/redmine/db/schema.rb")}
end

# startup unicorn
package "sysv-rc-conf" do
  action :install
end

template "/etc/init.d/unicorn" do
  source "service.unicorn.erb"
  owner "root"
  group "root"
  mode "0755"
  action :create
end

execute "Start unicorn" do
  command <<-EOS
    sysv-rc-conf unicorn on
    /etc/init.d/unicorn restart
  EOS
  not_if "/etc/init.d/unicorn status"
end

# Install nginx
execute "Install nginx" do
  command <<-EOS
    apt-get install -y python-software-properties
    add-apt-repository ppa:nginx/stable
    apt-get update -y
    apt-get install -y nginx
  EOS
  action :run
  not_if {File.exists?("/etc/nginx")}
end

template "/etc/nginx/sites-available/redmine" do
  source "nginx-conf.redmine.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

execute "Start nginx" do
  command <<-EOS
    ln -s /etc/nginx/sites-available/redmine /etc/nginx/sites-enabled/redmine
    rm /etc/nginx/sites-enabled/default
    service nginx restart
  EOS
  action :run
  not_if {File.exists?("/etc/nginx/sites-enabled/redmine")}
end
