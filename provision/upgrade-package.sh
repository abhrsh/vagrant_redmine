#!/bin/sh

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update

# Upgrade grub-pc
sudo apt-get install -y debconf-utils
printf "%s\t%s\t%s\n" grub-pc grub-pc/install_devices multiselect | sudo debconf-set-selections
printf "%s\t%s\t%s\t%s\n" grub-pc grub-pc/install_devices_empty boolean true | sudo debconf-set-selections
sudo apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy install grub-pc

# Upgrade and install
sudo apt-get -y upgrade
