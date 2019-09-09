# -*- mode: ruby -*-
# vi: set ft=ruby :

#ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  # Ceph-controller
  config.vm.define "controller" do |controller|
    controller.vm.box = "centos/7"
    controller.vm.hostname = "controller"
    controller.vm.network "public_network",
      use_dhcp_assigned_default_route: true
    controller.vm.network "private_network", ip: "172.42.42.100"
    controller.provision "shell", path: "script.sh"
    controller.vm.provider "virtualbox" do |v|
      v.name = "controller"
      v.memory = 2048
      v.cpus = 2
    end
  end
  NodeCount = 2
  # Ceph-compute
  (1..NodeCount).each do |i|
    config.vm.define "compute#{i}" do |workernode|
      workernode.vm.box = "centos/7"
      workernode.vm.hostname = "compute#{i}"
      workernode.vm.network "public_network",
        use_dhcp_assigned_default_route: true
      workernode.vm.network "private_network", ip: "172.42.42.10#{i}"
      workernode.provision "shell", path: "script.sh"
      workernode.vm.provider "virtualbox" do |v|
        v.name = "compute#{i}"
        v.memory = 1024
        v.cpus = 1
      end
    end
  end
  # Ceph-monitor
    config.vm.define "monitor" do |monitor|
    monitor.vm.box = "centos/7"
    monitor.vm.hostname = "monitor"
    monitor.vm.network "public_network",
      use_dhcp_assigned_default_route: true
    monitor.vm.network "private_network", ip: "172.42.42.103"
    monitor.provision "shell", path: "script.sh"
    monitor.vm.provider "virtualbox" do |v|
      v.name = "monitor"
      v.memory = 1024
      v.cpus = 1
    end
  end
end
