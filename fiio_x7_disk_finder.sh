#!/bin/env bash

# Get the before last drive and the last partition added. 
# Probably only useful if you don't have other USB drives attached!
# Used for my Fiio X7 as the drive/mount points seem to float aroud
# (probably as I'm not always unmounting properly)

lsblk -i | tail -3 | awk '{print $1}' | sed -n 'p;n' | tr -d \`-
