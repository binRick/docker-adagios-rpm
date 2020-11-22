#!/bin/bash
set -e


cmd="sudo podman exec -it $MY_CONTAINER_1_UUID tcpdump -nvvv $@"
eval $cmd
