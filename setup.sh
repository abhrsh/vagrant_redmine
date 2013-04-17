#!/bin/sh

if [ ! -d .vagrant ]; then
  vagrant up
  if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh
  fi
  vagrant ssh-config --host base >> ~/.ssh/config
fi
