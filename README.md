# Vagrant

Vagrant files to up a virtual machines with my setup.

## Vagrantfile

Vagrantfile is the main configuration file for a virtual machine.

### What does it do?

Up a virtual machine Ubuntu Trusty64 (14.04), with the following features and specifications:

- Private network IP: `192.168.100.101`
- Synchronize folders
  - `/var/www` (www-data group and user, dmode: 777, fmode: 666)
  - `/etc/apache2/sites-available`
  - `/etc/apache2/sites-enabled`
  - `~` -> `/vagrant` (/home directory)
- Set the memory to `1024`
- Set the name to `ubuntu-trusty64`
- Execute the shell provision by `VagrantSetup.sh` file

## VagrantSetup.sh

It is the file to shell provision. Execute a series of commands to install and configure the virtual machine, leaving it ready for use.

### What does it do?

- Update package files;
- Defines a default password for the MySQL and tools;
- Install basic packages (vim curl python-software-properties git-core);
- Install MySQL, PHPMyAdmin and some other modules;
- Install PHP, Apache and some other modules;
- Enables the Apache Rewrite Module;
- Install Composer dependency management tool (https://getcomposer.org/);
- Install Redis database nosql (http://redis.io/);

## Issues

### Kernel module not loaded

#### Error
```
VirtualBox is complaining that the kernel module is not loaded. Please
run `VBoxManage --version` or open the VirtualBox GUI to see the error
message which should contain instructions on how to fix this error.
```

#### Solution
Run 'sudo /etc/init.d/vboxdrv setup'

### Name already exists

#### Error
```
A VirtualBox machine with the name '<name-of-virtual-machine>' already exists.
Please use another name or delete the machine with the existing
name, and try again.
```

#### Solution
Run `vagrant global-status` to see all enviroments, and `vagrant destroy <id>` to deletes unnused enviroments.
**or**
Change the name of your virtual machine in Vagrantfile file:
```
	config.vm.provider "virtualbox" do |machine|
		machine.memory = 1024
		machine.name = "ubuntu-trusty64" # CHANGE THIS NAME
	end
```
**or**
Use `vagrant up --debug` to execute `up` with log.
Locate on results, your directory of virtual machines (look for line `Default machine folder`).
Access this with `cd <your-directory>` and delete the VM directory with `rm -Rf <vm-directory` (Use sudo if necessary).

### stdin

#### Error
`==> default: stdin: is not a tty` or
`==> default: dpkg-preconfigure: unable to re-open stdin: No such file or directory`

#### Solution
Enable the line on Vagrantfile, removing the `#` character
`# config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"`
