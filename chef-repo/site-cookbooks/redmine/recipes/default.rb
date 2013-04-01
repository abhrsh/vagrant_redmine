#
# Cookbook Name:: redmine
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install Redmine
git "/opt/redmine" do
  repository "https://github.com/redmine/redmine.git"
  reference "2.3-stable"
  action :sync
end

execute "Install Redmine" do
  cwd "/opt/redmine"
  command <<-EOS
    gem install rake --no-ri --no-rdoc
    gem install mysql2 --no-ri --no-rdoc
    bundle install --path vendor/bundle --without development test rmagick postgresql sqlite
    mkdir public/plugin_assets
    chown -R vagrant:vagrant files log tmp public/plugin_assets
    chmod -R 755 files log tmp public/plugin_assets
  EOS
  creates "/opt/redmine/vendor"
end

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

execute "assign-root-password" do
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

# Setup Redmine
execute "Initialize database" do
  cwd "/opt/redmine"
  command <<-EOS
    rake generate_secret_token
    RAILS_ENV=production rake db:migrate
    RAILS_ENV=production REDMINE_LANG=ja rake redmine:load_default_data
  EOS
  action :run
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
  mode "0644"
  action :create
end
