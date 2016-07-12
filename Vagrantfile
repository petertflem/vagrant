Vagrant.configure(2) do |config|

  # OS
  config.vm.box = "hashicorp/precise32"

  # Network
  config.vm.network "private_network", type: "dhcp"

  # Disable default sync folder
  config.vm.synced_folder '.', '/vagrant', disabled: true

  # Define sync folder (www root)
  config.vm.synced_folder 'www', '/var/www', create: true, group: "www-data", owner: "www-data"

  # Define sync folder for containing files that will be copied
  # to other destinations on the virutal machine
  config.vm.synced_folder 'vagrant-provision', '/etc/vagrant-provision', create: true

  # Provisioning
  config.vm.provision "shell", path: "setup.sh"

end
