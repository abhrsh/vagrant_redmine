#
# Cookbook Name:: java
# Recipe:: version5
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "base::python-software-properties"

execute "Install java5" do
  command <<-EOT
    add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ hardy multiverse"
    add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ hardy-updates multiverse"
    apt-get update

    apt-get -f install -y sun-java5-jdk

    add-apt-repository -r "deb http://us.archive.ubuntu.com/ubuntu/ hardy multiverse"
    add-apt-repository -r "deb http://us.archive.ubuntu.com/ubuntu/ hardy-updates multiverse"
    apt-get update
  EOT
  action :run
  not_if "which /usr/bin/java"
end
