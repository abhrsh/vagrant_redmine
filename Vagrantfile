# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "base"
  config.vm.hostname = "base"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.network :public_network

  config.vm.provision :shell do |s|
    s.inline = <<-EOS
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update

      # Upgrade grub-pc
      sudo apt-get install -y debconf-utils
      printf "%s\t%s\t%s\n" grub-pc grub-pc/install_devices multiselect | sudo debconf-set-selections
      printf "%s\t%s\t%s\t%s\n" grub-pc grub-pc/install_devices_empty boolean true | sudo debconf-set-selections
      sudo apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy install grub-pc

      # Upgrade and install
      sudo apt-get -y upgrade
      sudo apt-get -y install git make curl zlib1g-dev libyaml-dev

      # Install Ruby 1.9.3
      cd /tmp
      wget wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p392.tar.gz
      tar xzf ruby-1.9.3-p392.tar.gz
      cd ruby-1.9.3-p392
      ./configure --prefix=/opt/ruby
      make
      sudo make install
      echo 'export PATH="/opt/ruby/bin:%PATH"' >> ~/.bashrc
      source ~/.bashrc

      # Install gem
      sudo gem update --system
      sudo gem install psych bundler berkshelf chef --no-ri --no-rdoc

      # Chef
      cd /vagrant/chef-repo
      berks install --path cookbooks
      sudo chef-solo -c solo.rb -j nodes/localhost.json
    EOS
  end

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  # config.vm.provision :chef_solo do |chef|
  #   chef.cookbooks_path = "../my-recipes/cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { :mysql_password => "foo" }
  # end
end
