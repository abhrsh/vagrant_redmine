#
# Cookbook Name:: redmine
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "git clone https://github.com/redmine/redmine.git" do
  cwd "/opt"
  not_if { ::File.exists?("/opt/redmin") }
end
