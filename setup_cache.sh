#!/bin/bash
cache_container_name=packages

cmd="sudo podman run \
    --name='$cache_container_name' \
    --rm=true \
    --volume=repository-package-cache:/var/cache/nginx:Z \
    docker.io/aesiniath/proxy:latest"
