#!/bin/bash
# Install Master Mesos, Zookeeper, Chronos and Marathon

# Add Key and Repository
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list

# Run Your Update (Or You Shall Not Pass!)
sudo apt-get -y update

# On Masters, Install Zookeeper, Mesos, Chronos and Marathon

sudo apt-get install -y mesos marathon chronos

# Configure Mesos
echo $(ec2metadata --local-ipv4) | sudo tee /etc/mesos-master/ip
sudo cp /etc/mesos-master/ip /etc/mesos-master/hostname

# Configure Marathon
sudo mkdir -p /etc/marathon/conf
sudo cp /etc/mesos-master/hostname /etc/marathon/conf

# Define Zookeeper Master for Marathon
sudo cp /etc/mesos/zk /etc/marathon/conf/master
sudo cp /etc/marathon/conf/master /etc/marathon/conf/zk

# If more than one node, Edit the Following to include comma-separated list of ZK nodes:
#sudo nano /etc/marathon/conf/zk

# Ensure Only Master Processes Are Running
sudo service stop mesos-slave
echo manual | sudo tee /etc/init/mesos-slave.override

# Now Start the Party!
sudo service zookeeper restart
sudo service mesos-master restart
sudo service marathon restart
sudo service chronos restart
echo "Connect to Marathon here: http://"`ec2metadata --public-hostname`":8080"
echo "Connect to Mesos here: http://"`ec2metadata --public-hostname`":5050"
echo "Connect to Chronos here: http://"`ec2metadata --public-hostname`":4400"
