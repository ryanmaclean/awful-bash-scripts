#!/bin/bash

# Get current DHCP leases and hostnames registered on your Ubiquity EdgeRouter Lite 3

## First we set run to our vyatta cmd wrapper so we can call multiple commands
run=/opt/vyatta/bin/vyatta-op-cmd-wrapper

## Next we call our wrapper, then our command
$run show dhcp leases | tail -n +3 | awk '{print $1, $NF}'
