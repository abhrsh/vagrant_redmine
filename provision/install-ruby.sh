#!/bin/sh

# Install Ruby 1.9.3 rbenv
which rbenv > /dev/null
if [ $? -ne 0 ]; then
  apt-get -y install curl make git build-essential zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
  apt-get remove -y ruby1.8 ruby1.9 rubygems

  export RBENV_ROOT=/opt/rbenv
  git clone git://github.com/sstephenson/rbenv.git $RBENV_ROOT
  chgrp -R adm $RBENV_ROOT
  chmod -R g+rwxXs $RBENV_ROOT

  mkdir -p $RBENV_ROOT/plugins
  git clone git://github.com/sstephenson/ruby-build.git $RBENV_ROOT/plugins/ruby-build

  RBENV_SHELL=/etc/profile.d/rbenv.sh
  echo 'export RBENV_ROOT="/opt/rbenv"'       > $RBENV_SHELL
  echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> $RBENV_SHELL
  echo 'eval "$(rbenv init -)"'              >> $RBENV_SHELL

  export PATH="$RBENV_ROOT/shims:$RBENV_ROOT/bin:$PATH"
  rbenv install 1.9.3-p392
  rbenv rehash
  rbenv global  1.9.3-p392

  gem update --no-ri --no-rdoc
  gem install rbenv-rehash --no-ri --no-rdoc
  rbenv rehash
  gem install bundler chef berkshelf --no-ri --no-rdoc
fi
