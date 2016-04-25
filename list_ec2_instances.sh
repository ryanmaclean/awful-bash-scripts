#!/bin/bash

aws ec2 describe-instances | grep Value | awk '{print $2}' | cut -c2- | cut -d "\"" -f 1
