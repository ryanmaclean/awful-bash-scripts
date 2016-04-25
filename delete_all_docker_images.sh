#!/bin/bash
docker rmi -f $(docker images | sed '1d' | awk '{print $3}')
