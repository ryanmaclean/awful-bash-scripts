#!/bin/bash

# Gitlab Runner script to mount an EFS cache on Ubuntu hosts in AWS EC2
# DEFINE FILESYSTEM_NAME
sudo apt-get install -y nfs-common

sudo mkdir /nfscache
sudo sed -i.bak '/xvdf/d' /etc/fstab
echo "$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).FILESYSTEM_NAME.efs.us-east-1.amazonaws.com:/ /nfscache nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" | sudo tee -a /etc/fstab
sudo mount -a

#sudo mkdir /nfscache/cache
#sudo mkdir /nfscache/build-cache
sudo chown gitlab-runner:gitlab-runner /nfscache/cache
sudo chown gitlab-runner:gitlab-runner /nfscache/build-cache
#sudo chmod -R 755 /nfscache/cache
sudo rm -rf /cache
sudo ln -s /nfscache/cache /cache
sudo rm -rf /build-cache
sudo ln -s /nfscache/build-cache /build-cache
