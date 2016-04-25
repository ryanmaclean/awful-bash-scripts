#!/bin/bash
docker rm $(docker ps -a | sed '1d' | awk '{print $1}')
