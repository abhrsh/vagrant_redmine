# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "base"
  config.vm.hostname = "base"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.network :public_network
  config.vm.network :forwarded_port, guest: 22, host: 22
  config.vm.synced_folder "c:/", "/c"

  config.vm.provision :shell, :path => "provision/exec-all.sh"

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", "512"]
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  end
end
