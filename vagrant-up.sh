#!/bin/sh
vagrant up
vagrant ssh-config --host base >> ~/.ssh/config
