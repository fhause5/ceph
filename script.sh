#!/bin/bash

yum update -y
yum install -y git nano ntp ntpdate ntp-doc

sudo tee -a /etc/hosts << EOF
172.42.42.100    controller
172.42.42.101    compute1
172.42.42.102    compute2
172.42.42.103    monitor
EOF


ntpdate europe.pool.ntp.org
systemctl start ntpd
systemctl enable ntpd

useradd cephadm && echo "CephAdm@123#" | passwd --stdin cephadm
echo "cephadm ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/cephadm
chmod 0440 /etc/sudoers.d/cephadm
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && sudo service sshd restart 
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && sudo service sshd restart 


# On controller:

########################################################################################
ssh-keygen -f ~/.ssh/id_rsa -N ""
for host in controller compute1 compute2 monitor ; do ssh-copy-id -i ~/.ssh/id_rsa.pub $host; done

sudo tee -a ~/.ssh/config << EOF
Host ceph-compute01
   Hostname ceph-compute01
   User cephadm
Host ceph-compute02
   Hostname ceph-compute02
   User cephadm
Host ceph-monitor
   Hostname ceph-monitor
   User cephadm
EOF

chmod 644 ~/.ssh/config
sudo rpm -Uvh https://download.ceph.com/rpm-mimic/el7/noarch/ceph-release-1-1.el7.noarch.rpm
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum update -y && sudo yum install ceph-deploy python2-pip  -y
sudo yum install -y leveldb-1.12.0-11.el7.x86_64.rpm
mkdir ceph_cluster
cd ceph_cluster/
ceph-deploy new monitor
public network = 172.42.42.0/24
ceph-deploy install controller compute1 compute2 monitor
ceph-deploy mon create-initial
ceph-deploy admin controller compute1 compute2 monitor

ceph-deploy mgr create compute1 compute2


