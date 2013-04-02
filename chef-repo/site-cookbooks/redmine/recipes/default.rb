#
# Cookbook Name:: redmine
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


# Install MySQL Client
%w{mysql-client libmysqlclient-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

# Install MySQL Server
%w{mysql-server}.each do |pkg|
  package pkg do
    action :install
  end
end

%w{rake mysql2}.each do |pkg|
  gem_package pkg do
    options("--no-ri --no-rdoc")
    action :install
  end
end

# Install Redmine
git "/opt/redmine" do
  repository "https://github.com/redmine/redmine.git"
  reference "2.3-stable"
  action :sync
end

execute "Install Redmine" do
  cwd "/opt/redmine"
  command <<-EOS
    bundle install --path vendor/bundle --without development test rmagick postgresql sqlite
    mkdir public/plugin_assets
    chown -R vagrant:vagrant files log tmp public/plugin_assets
    chmod -R 755 files log tmp public/plugin_assets
  EOS
  creates "/opt/redmine/vendor"
end

execute "Assign MySQL root password" do
  command "/usr/bin/mysqladmin -u root password pass"
  action :run
  only_if "/usr/bin/mysql -u root -e 'show databases;'"
end

# Create database for Redmine
template "/etc/mysql/redmine.sql" do
  source "redmine.sql.erb"
  owner "root"
  group "root"
  mode "0600"
  action :create
end

execute "Create database redmine" do
  command "/usr/bin/mysql -u root -ppass < /etc/mysql/redmine.sql"
  action :run
  not_if "/usr/bin/mysql -u root -ppass redmine -e 'show databases;'"
end

template "/opt/redmine/config/database.yml" do
  source "database.yml.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

# Setup unicorn
template "/opt/redmine/Gemfile.local" do
  source "Gemfile.local.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

execute "Install unicorn" do
  cwd "/opt/redmine"
  command <<-EOS
    bundle install --path vendor/bundle --without development test rmagick postgresql sqlite
  EOS
end

template "/opt/redmine/config/unicorn.rb" do
  source "unicorn.rb.erb"
  owner "root"
  group "root"
  mode "0755"
  action :create
end

template "/etc/init.d/unicorn" do
  source "service.unicorn.erb"
  owner "root"
  group "root"
  mode "0755"
  action :create
end

package "sysv-rc-conf" do
  action :install
end

# Install nginx
execute "Install nginx" do
  command <<-EOS
    apt-get install -y python-software-properties
    add-apt-repository ppa:nginx/stable
    apt-get update
    apt-get install -y nginx
  EOS
  action :run
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
    ln -s /etc/nginx/sites-available/redmine.conf /etc/nginx/sites-enabled/redmine.conf
    rm /etc/nginx/sites-enable/default
    service nginx restart
  EOS
  action :run
end

# Initialize database Redmine
execute "Initialize database" do
  cwd "/opt/redmine"
  command <<-EOS
    rake generate_secret_token
    RAILS_ENV=production rake db:migrate
    RAILS_ENV=production REDMINE_LANG=ja rake redmine:load_default_data
  EOS
  action :run
end

execute "Start unicorn" do
  command <<-EOS
    sysv-rc-conf unicorn on
    /etc/init.d/unicorn restart
  EOS
end
