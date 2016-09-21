Vagrant.configure(2) do |config|

  # OS
  config.vm.box = "hashicorp/precise32"

  # Network
  config.vm.network "private_network", type: "dhcp"

  # For mailcatcher
  # config.vm.network "forwarded_port", guest: 1080, host: 1080

  # Disable default sync folder
  config.vm.synced_folder '.', '/vagrant', disabled: true

  # Define sync folder (www root)
  config.vm.synced_folder 'www', '/var/www', create: true, group: "www-data", owner: "www-data"

  # Define sync folder for containing files that will be copied
  # to other destinations on the virutal machine
  config.vm.synced_folder 'vagrant-provision', '/etc/vagrant-provision', create: true

  config.vm.provider "virtualbox" do |v|
    v.name = "dev" # VM name
    v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/var_www","1"] # Enable symlinks on shared folders, not sure if this is needed
    v.customize ["modifyvm", :id, "--ioapic", "on"] # Required for having more than 1 CPU
    v.memory = 2048
    v.cpus = "3"
  end

  # Provisioning
  config.vm.provision "shell", path: "setup.sh" do |s|
    s.args = ENV['mysqlpassword'] # e.g: mysqlpassword=mypassword vagrant up
  end

end
