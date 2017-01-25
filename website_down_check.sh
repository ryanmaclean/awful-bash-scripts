#!/bin/env bash 

# Check a few websites using a list to see if they are down
 
for i in qa dev test prod; do curl -fsS https://service-$i.example.com -o /dev/null || echo $i "website is down"; done
