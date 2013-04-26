#
# Cookbook Name:: tomcat
# Recipe:: version5.5
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "java::version5"

execute "Install tomcat5.5" do
  command <<-EOT
    add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ hardy multiverse"
    add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ hardy-updates multiverse"
    add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ hardy-security universe"
    apt-get update

    apt-get install -y tomcat5.5 tomcat5.5-admin tomcat5.5-webapps

    add-apt-repository -r "deb http://us.archive.ubuntu.com/ubuntu/ hardy multiverse"
    add-apt-repository -r "deb http://us.archive.ubuntu.com/ubuntu/ hardy-updates multiverse"
    add-apt-repository -r "deb http://us.archive.ubuntu.com/ubuntu/ hardy-security universe"
    apt-get update
  EOT
  action :run
  not_if "ls /usr/share/tomcat5.5"
end
