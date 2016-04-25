#! /bin/bash

# Make sure both localhost and the AWS EC2 hostname have been defined

echo "127.0.0.1 localhost" | sudo tee --append /etc/hosts
echo "127.0.0.1" `ec2metadata --local-hostname` | sudo tee --append /etc/hosts

## Remove --append to overwrite the file
