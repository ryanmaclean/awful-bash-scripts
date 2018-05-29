#!/usr/bin/env bash

# Get the before last drive and the last partition added. 
# Probably only useful if you don't have other USB drives attached!
# Used for my Fiio X7 as the drive/mount points seem to float aroud
# (probably as I'm not always unmounting properly)

# Usage: for $i in $(fiio_disk_finder.sh); do mount -t ALLTHETHINGS; done

# explanation: 
# use -i for lsbk in order to not print out ANSI tree chars
# grab the last three lines of the output
# grab the first column
# grab the odd lines
# remove the ASCII tree chars

lsblk -i | tail -3 | awk '{print $1}' | sed -n 'p;n' | tr -d \`-
