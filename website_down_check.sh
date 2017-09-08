#!/bin/env bash 

# Check a few websites using a list to see if they are down
# Requires that cURL is installed

## The sites are in the format:
## https://service-qa.example.com
## https://service-dev.example.com
## https://service-test.example.com
## https://service-prod.example.com

## The loop will silently `curl` the URLs, pipe output to /dev/null,
## and if it fails, echo that the site is down, prefixed with the site name.
## Any action can be done instead or in addition to the echo, for example
## you could make a rest call to an alert mechanism with the failure message
## as a payload. 

for i in qa dev test prod; do
    curl -fsS https://service-$i.example.com -o /dev/null || echo $i "website is down";
done
