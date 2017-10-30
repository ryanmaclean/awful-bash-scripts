#! /usr/bin/env bash

for i in $(docker ps | awk '{print $1}' | tail -n +2); 
  do echo Killing Docker container: && docker kill $i && echo done;
done
