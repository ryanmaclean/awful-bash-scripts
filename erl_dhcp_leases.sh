#!/bin/bash

# Get current DHCP leases and hostnames registered on your Ubiquity EdgeRouter Lite 3

show dhcp leases | awk '{print $1, $NF}' | tail -n +3
