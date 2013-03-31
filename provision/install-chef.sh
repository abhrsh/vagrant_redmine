#!/bin/sh

sudo apt-get install -y git-core curl
sudo gem install bundler berkshelf chef --no-ri --no-rdoc

# Chef
cd /vagrant/chef-repo
berks install --path cookbooks
