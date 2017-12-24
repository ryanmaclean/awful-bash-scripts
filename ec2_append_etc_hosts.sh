#! /bin/bash

# Make sure both localhost and the AWS EC2 hostname have been defined in /etc/hosts
## Remove -a (append) to overwrite the file
echo "127.0.0.1 localhost" | sudo tee -a /etc/hosts
echo "127.0.0.1" `ec2metadata --local-hostname` | sudo tee - /etc/hosts
