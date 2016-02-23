Vagrant.configure("2") do |config|

  # Base image
  config.vm.box = "ubuntu/trusty64"

  # Network forwarding
  config.vm.network "public_network", ip: "192.168.0.24"
  config.vm.network :forwarded_port, guest: 80, host: 10080, auto_correct: true
  config.vm.network :forwarded_port, guest: 7070, host: 17070, auto_correct: true
  config.vm.network :forwarded_port, guest: 8080, host: 18080, auto_correct: true
  config.vm.network :forwarded_port, guest: 27017, host: 27017, auto_correct: true

  # Folder syncs
  config.vm.synced_folder ".", "/var/www", create: true, group: "www-data", owner: "www-data"
  config.vm.synced_folder "./workspace", "/opt/workspace", create: true, group: "vagrant", owner: "vagrant"


  # Virtualbox parameters 2gb mem and 2 cpus
  config.vm.provider "virtualbox" do |v|
    v.name = "Multipurpose"
    v.memory = 2048
    v.cpus = 2
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "90"]
  end

  # Simple setup
  config.vm.provision "shell" do |s|
    s.path = "provision/setup.sh"
  end
end
