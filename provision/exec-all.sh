#!/bin/sh

ROOT=/vagrant
PROVISION=$ROOT/provision
CHEF_REPO=$ROOT/chef-repo

. $PROVISION/upgrade-package.sh
. $PROVISION/install-ruby.sh

cd $CHEF_REPO
berks install --path cookbooks
chef-solo -c solo.rb -j nodes/base.json
#chef-solo -c solo.rb -j nodes/project-server.json
