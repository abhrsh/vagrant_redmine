#
# Cookbook Name:: redmine
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


# Install MySQL Server
%w{mysql-server}.each do |pkg|
  package pkg do
    action :install
  end
end

# Install MySQL Client
%w{mysql-client libmysqlclient-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

# Install gem mysql2
%w{mysql2}.each do |pkg|
  gem_package pkg do
    options("--no-ri --no-rdoc")
    action :install
  end
end

execute "Assign MySQL root password" do
  command "/usr/bin/mysqladmin -u root password pass"
  action :run
  only_if "/usr/bin/mysql -u root -e 'show databases;'"
end
