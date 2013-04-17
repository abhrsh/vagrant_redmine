#
# Cookbook Name:: base
# Recipe:: svn
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


%w{subversion git-svn}.each do |pkg|
  package pkg do
    action :install
  end
end
