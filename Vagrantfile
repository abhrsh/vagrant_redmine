# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "base"
  config.vm.hostname = "base"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.network :public_network

  config.vm.provision :shell, :path => "provision/exec-all.sh"

  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
end
