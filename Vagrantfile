# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|



  # Ceph-controller
  config.vm.define "controller" do |controller|
    controller.vm.box = "centos/7"
    controller.vm.hostname = "controller.example.com"
    controller.vm.network "private_network", ip: "172.42.42.100"
    controller.vm.provider "virtualbox" do |v|
      v.name = "controller"
      v.memory = 2048
      v.cpus = 2
    end
  end


  # 
  NodeCount = 2

  # Ceph-compute
  (1..NodeCount).each do |i|
    config.vm.define "compute#{i}" do |workernode|
      workernode.vm.box = "centos/7"
      workernode.vm.hostname = "compute#{i}.example.com"
      workernode.vm.network "private_network", ip: "172.42.42.10#{i}"
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
    monitor.vm.hostname = "ceph-monitor"
    monitor.vm.network "private_network", ip: "172.42.42.103"
    monitor.vm.provider "virtualbox" do |v|
      v.name = "monitor"
      v.memory = 1024
      v.cpus = 1
    end
  end


end
