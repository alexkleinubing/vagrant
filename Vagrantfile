Vagrant.configure(2) do |config|

	config.vm.box = "ubuntu/trusty64"
	# config.vm.box_url = "package.box"
	# config.vm.box_check_update = false

	config.vm.network "forwarded_port", guest: 80, host: 8080
	config.vm.network "private_network", ip: "192.168.100.101"

	config.vm.synced_folder "~", "/vagrant", owner: "vagrant", group: "vagrant"
	config.vm.synced_folder ".", "/var/www"
	# :owner => "www-data", :group => "www-data",
	# mount_options: ['dmode=777','fmode=666']
	# config.vm.synced_folder "/etc/apache2/sites-available", "/etc/apache2/sites-available"
	# config.vm.synced_folder "/etc/apache2/sites-enabled", "/etc/apache2/sites-enabled"

	config.vm.provider "virtualbox" do |machine|
		machine.memory = 1024
		machine.name = "ak-machine"
	end

	# resolve "stdin: is not a tty warning", related issue and proposed fix: 
	# https://github.com/mitchellh/	vagrant/issues/1673
	config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

	config.vm.provision :shell, path: "provision/vagrant-setup.sh", privileged: false
end

