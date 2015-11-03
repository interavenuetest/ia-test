# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Vagrant Box
  config.vm.box = "puppetlabs/ubuntu-14.04-64-nocm"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1536"]
  end
  config.vm.hostname = "internavenue-vagrant"
  config.vm.network :private_network, ip: "192.168.2.20"
  config.vm.synced_folder "./saltstack", "/srv"
  # Provisioner
  config.vm.provision "shell", path: "bootstrap.sh"

  config.vm.post_up_message = "Woot! The Vagrant box is created. Sit back, relax and give it 20 minutes before you head over to https://192.168.2.20"
end
