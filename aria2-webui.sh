#!/bin/bash

# Run Aria2's WebUI on port 9100
# Mount /mnt/downloads to the container's "Downloads" folder
docker run -d -v /mnt/downloads:/Downloads -p 6800:6800 -p 9100:8080 --name="webui-aria2" guyschaos/webui-aria2
