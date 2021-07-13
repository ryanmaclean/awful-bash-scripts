#!/usr/bin/env bash 

## Script to install docker-ce on Rocky Linux
## Run using `sudo rocky-docker.sh`
## Testing on a fresh install of Rocky Linux 8.4 x64 July 2021 

# Ensuring "GROUP" variable has not been set elsewhere
unset GROUP

echo "Removing podman and installing Docker CE"
dnf remove -y podman buildah
dnf install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io

echo "Setting up docker service"
systemctl enable docker
systemctl start docker
systemctl status docker

echo "Adding permissions to current user for docker, attempting to reload group membership"
usermod -aG docker -a $USER
GROUP=$(id -g) # list group membership, but also save as var
newgrp docker  # set primary group to docker group 
newgrp $GROUP  # set it back to the one we started with
unset GROUP    # unset the variable again just in case

echo "Install completed, though you will probably require logout/login if the following command fails:"
docker ps
