#!/usr/bin/env bash

# Get the latest version number for Hashicorp Terraform

curl -v --silent https://releases.hashicorp.com/terraform/ 2>&1 | grep -i -e "<a href" | head -2 | grep terraform | awk -F[\>\<] '{print $3}'
