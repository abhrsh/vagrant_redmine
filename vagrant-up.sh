#!/bin/sh
vagrant up
if [ ! -d ~/.ssh ]; then mkdir ~/.ssh; fi
vagrant ssh-config --host base >> ~/.ssh/config
