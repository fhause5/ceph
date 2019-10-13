

* Add new volume in virtualbox for osd

* storage > Storage Devices > + Controller: SATA newVirtualDisk1
```
#################
#!/bin/bash

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
sudo sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && sudo service sshd restart

```
# Add OSD

```
sudo fdisk -l /dev/sdb
sudo parted -s /dev/sdb mklabel gpt mkpart primary xfs 0% 100%
sudo mkfs.xfs -f /dev/sdb
sudo fdisk -s /dev/sdb
sudo blkid -o value -s TYPE /dev/sdb

```
### result xfs

# On controller:

########################################################################################

ssh-keygen -f ~/.ssh/id_rsa -N ""

for host in controller compute1 compute2 monitor ; do ssh-copy-id -i ~/.ssh/id_rsa.pub $host; done

```
sudo tee -a ~/.ssh/config << EOF
Host controller
   Hostname controller
   User cephadm
Host compute1
   Hostname compute1
   User cephadm
Host compute2
   Hostname compute2
   User cephadm
Host monitor
   Hostname monitor
   User cephadm

EOF

chmod 644 ~/.ssh/config
sudo rpm -Uvh https://download.ceph.com/rpm-mimic/el7/noarch/ceph-release-1-1.el7.noarch.rpm
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum update -y && sudo yum install ceph-deploy python2-pip  -y
sudo yum install -y leveldb-1.12.0-11.el7.x86_64.rpm

```

mkdir ceph_cluster
cd ceph_cluster/
ceph-deploy new monitor
nano ceph.conf
public network = 172.42.42.0/24
osd pool default size = 2

# It will connect to all the servers bellow and download packages NEED TIME !
ceph-deploy install controller compute1 compute2 monitor

################
## Go 
```
ceph-deploy mon create-initial
ceph-deploy gatherkeys monitor
ceph-deploy admin controller compute1 compute2 monitor
ceph-deploy mgr create compute1 compute2
ceph-deploy disk list compute1 compute2
ceph-deploy disk zap compute1 /dev/sdb
ceph-deploy disk zap compute2 /dev/sdb
# Tag as OSD
ceph-deploy osd create --data /dev/sdb compute1
ceph-deploy osd create --data /dev/sdb compute2


# Check status
ssh monitor
sudo ceph health
sudo ceph -s

```
