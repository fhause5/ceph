#!/bin/bash
################
##  All nodes ##
################

yum update -y
yum install -y git nano ntp ntpdate ntp-doc python python-pip parted

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
echo "SUCCESS"
