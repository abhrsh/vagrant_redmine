#!/bin/sh

sudo apt-get remove -y ruby1.8 ruby1.9 rubygems
sudo apt-get install -y ruby1.9.3

#sudo apt-get -y install curl make zlib1g-dev libyaml-dev

# Install Ruby 1.9.3
#cd /tmp
#wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p392.tar.gz
#tar xzf ruby-1.9.3-p392.tar.gz
#cd ruby-1.9.3-p392
#./configure --prefix=/opt/ruby
#make
#sudo make install
#export PATH=/opt/ruby/bin:$PATH

# Install gem
#sudo gem update --system
#sudo gem install psych --no-ri --no-rdoc
