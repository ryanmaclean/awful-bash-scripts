#!/bin/bash
# Install Mesos on Slaves

# Ubuntu Ec2 Fixes
sudo locale-gen en_CA.UTF-8 en_US.UTF-8
echo "127.0.0.1" `ec2metadata --local-hostname` | sudo tee --append /etc/hosts

# Add Key and Repository
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list

# Run Your Update (Or You Shall Not Pass!)
sudo apt-get -y update

# On Slaves, Install Mesos
sudo apt-get install -y mesos

# Configure Mesos
echo $(ec2metadata --local-ipv4) | sudo tee /etc/mesos-slave/ip
sudo cp /etc/mesos-slave/ip /etc/mesos-slave/hostname

# Add Zookeeper Master to Slave
echo "zk://10.5.5.92:2181/mesos" | sudo tee /etc/mesos/zk

# If more than one node, Edit the Following to include comma-separated list of ZK nodes:
#sudo nano /etc/marathon/conf/zk

# Ensure Only Slave Processes Are Running
sudo service stop zookeeper
echo manual | sudo tee /etc/init/zookeeper.override

echo manual | sudo tee /etc/init/mesos-master.override
sudo service stop mesos-master

# Now Start the Party!
sudo service mesos-slave restart
