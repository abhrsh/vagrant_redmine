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
    sudo gem install rake mysql2 --no-ri --no-rdoc
    bundle install --path vendor/bundle --without development test rmagick postgresql sqlite
    sudo mkdir public/plugin_assets
    sudo chown -R vagrant:vagrant files log tmp public/plugin_assets
    sudo chmod -R 755 files log tmp public/plugin_assets
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
execute "Generate secret token" do
  cwd "/opt/redmine"
  command <<-EOS
    rake generate_secret_token
    RAILS_ENV=production rake db:migrate
  EOS
  action :run
end

