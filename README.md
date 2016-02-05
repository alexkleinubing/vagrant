# Vagrant Configurations

Vagrant files to up a virtual machines with my setup.

## Vagrantfile

Vagrantfile is the main configuration file for a virtual machine.

##### What does it do?

Up a virtual machine Ubuntu Trusty64 (14.04), with the following features and specifications:

- Private network IP: `192.168.100.101`
- Synchronize folders
  - "up" folder -> `/var/www`
  - `~` -> `/vagrant` (/home directory)
- Set the memory to `1024`
- Execute the shell provision file

## VagrantSetup.sh

It is the file to shell provision. Execute a series of commands to install and configure the virtual machine, leaving it ready for use.

##### What does it do?

- Update package files;
- Defines a default password for the MySQL and tools;
- Install basic packages (vim curl python-software-properties git-core);
- Install MySQL, PHPMyAdmin and some other modules;
- Install PHP, Apache and some other modules;
- Enables the Apache Rewrite Module;
- Install `vhost` command to create Virtual Hosts
- Install Composer dependency management tool (https://getcomposer.org/);
- Install Redis database nosql (http://redis.io/);
- Install RVM and Ruby
- Install NodeJS and NPM

## Creating projects

You can create a project dir `/var/www/myproject` and use `vhost` command to create a Apache's Virtual Hosts   
You can create a Jekyll project with `jekyll new myproject`

## Issues

See the "Wiki" section/tab.
