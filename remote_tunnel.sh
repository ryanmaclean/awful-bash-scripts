#!/bin/bash

read -p "Enter the host through which you'd liek to tunnel: " name
name=${name:-remote}

ssh -C -D 1080 $name -o 'GatewayPorts yes' -q

# Essentially:
### -C - compression
### -D - tunnel and port (use 127.0.0.1 as Socks and 1080 in FF)
### -o - option, this one stops the annoying "Channel 9 dropped" errors
### -q - quiet, to get rid of any other errors
