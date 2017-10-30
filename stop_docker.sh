#!/usr/bin/env bash

# Enumerate all running containers, run `docker kill` on each of the IDs
# Let the user know via console what is happening. 

for i in $(docker ps | awk '{print $1}' | tail -n +2); 
  do echo Killing Docker container: && docker kill $i && echo done;
done
