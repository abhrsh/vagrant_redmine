#!/bin/sh

if [ ! -f /var/log/apt-upgrade.log ]; then
  export DEBIAN_FRONTEND=noninteractive
  apt-get update

  # Upgrade grub-pc
  apt-get install -y debconf-utils
  printf "%s\t%s\t%s\n" grub-pc grub-pc/install_devices multiselect | sudo debconf-set-selections
  printf "%s\t%s\t%s\t%s\n" grub-pc grub-pc/install_devices_empty boolean true | sudo debconf-set-selections
  apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy install grub-pc

  # Upgrade and install
  apt-get -y upgrade
  echo done> /var/log/apt-upgrade.log
fi
