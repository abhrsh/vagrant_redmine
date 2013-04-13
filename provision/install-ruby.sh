#!/bin/sh

# Install Ruby 1.9.3 rbenv
which rbenv > /dev/null
if [ $? -ne 0 ]; then
  apt-get -y install git build-essential zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
  apt-get remove -y ruby1.8 ruby1.9 rubygems

  RBENV_ROOT=/opt/rbenv
  git clone git://github.com/sstephenson/rbenv.git $RBENV_ROOT
  chgrp -R adm $RBENV_ROOT
  chmod -R g+rwxXs $RBENV_ROOT

  mkdir -p $RBENV_ROOT/plugins
  git clone git://github.com/sstephenson/ruby-build.git $RBENV_ROOT/plugins/ruby-build

  echo 'export RBENV_ROOT="/opt/rbenv"'       > /etc/profile.d/rbenv.sh
  echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
  echo 'eval "$(rbenv init -)"'              >> /etc/profile.d/rbenv.sh
  source /etc/profile.d/rbenv.sh

  rbenv install 1.9.3-p392
  rbenv rehash
  rbenv global  1.9.3-p392

  gem install rbenv-rehash
  gem install mysql2
  gem update
fi
