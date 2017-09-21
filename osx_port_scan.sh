#!/bin/bash
# Apple OSX Netcat Port Scan Script
###################################
# Nothing fancy, just a loop with GNU Netcat

# Check to see if Homebrew is installed, and install it if it is not
command -v brew >/dev/null 2>&1 || { echo >&2 "You will need Homebrew to use this tool, installing now"; /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; }

# Check to see if `netcat` is installed, install it if it is not
command -v netcat >/dev/null 2>&1 || { echo >&2 "You will also need netcat in order to use this tool, installing it now"; brew install netcat; }

# Prompt the user for the port which we will scan
read -p "Which port would you like to scan? The default is [80]:" PORT
PORT=${PORT:-80}

# Prompt the user for the C-class range we will scan
read -p "For which range? The default is [10.0.1.]:" RANGE
RANGE=${RANGE:-10.0.1.}

# Removed the start and end IP blocks and scan 255 by default
#echo "From what starting IP? The default is 1"
#read -p "From what starting IP? The default is [1]:" STARTIP
#STARTIP=${STARTIP:-1}

for i in {1..254}; do netcat -vnz -w 1 $RANGE$i $PORT & done
