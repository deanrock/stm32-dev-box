# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.hostname = 'stm32-dev-box'

  config.vm.synced_folder ".", "/home/vagrant/files"

  config.vm.provider :virtualbox do |vb|
  		vb.customize ["modifyvm", :id, "--memory", "1024"]
        vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/cross-compiler", "1"]
  end

  config.vm.provision "shell", path: "bootstrap.sh"
end
