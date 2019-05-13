# -*- mode: ruby -*-
# vi: set ft=ruby :

INSTALLER_IP = "192.168.150.100"

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.box_check_update = false

   if Vagrant.has_plugin?('landrush')
     config.landrush.enabled = true
     config.landrush.tld = 'example.com'
     config.landrush.guest_redirect_dns = false
   end

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false

  config.vm.provision "shell", inline: <<-SHELL
    chmod +x /vagrant/*.sh
    /vagrant/installer.sh
  SHELL

  config.vm.provision "keys", type: "shell", inline: <<-SHELL
    chmod -R og-rw /home/vagrant/.ssh/
  SHELL


  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus   = "1"
  end

  config.vm.define "installer" do |node|
    node.vm.network "private_network", ip: "#{INSTALLER_IP}"
    node.vm.hostname = "installer.example.com"
  end
end
