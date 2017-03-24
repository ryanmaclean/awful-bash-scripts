#!/usr/bin/env bash

# Modified version of this gist: https://gist.github.com/Adron/90863e51c8c5c0ad2049890bcd8abbfb 

# Install requirements
sudo apt-get update && apt-get install jq unzip

# Get URLs for most recent versions
terraform_url=$(curl --silent https://releases.hashicorp.com/index.json | jq '{terraform}' | egrep "linux.*64" | sort -rh | head -1 | awk -F[\"] '{print $4}')
packer_url=$(curl --silent https://releases.hashicorp.com/index.json | jq '{packer}' | egrep "linux.*64" | sort -rh | head -1 | awk -F[\"] '{print $4}')

# Create directories
cd
mkdir packer
mkdir terraform


# Change directory to terraform
cd ~/terraform

# Download Terraform. URI: https://www.terraform.io/downloads.html
curl -o terraform.zip $terraform_url
# Unzip and install
unzip terraform.zip
# Remove zip
rm terraform.zip


# Change directory to Packer
cd ~/packer

# Download Packer. URI: https://www.packer.io/downloads.html
curl -o packer.zip $packer_url
# Unzip and install
unzip packer.zip
# Remove zip
rm packer.zip


echo '
# Terraform & Packer Paths.
export PATH=~/terraform/:~/packer/:$PATH
' >>~/.bash_profile

source ~/.bash_profile
