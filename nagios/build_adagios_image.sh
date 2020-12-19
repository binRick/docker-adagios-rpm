#!/bin/bash
PROJECT_NAME=naemon
JOBS=4
[[ ! -d RPM_CACHE ]] && mkdir RPM_CACHE

set +e
podman-compose -f container-adagios-compose.yaml down 2>/dev/null

set -e
#podman-compose -p $PROJECT_NAME -f container-adagios-compose.yaml up --build --abort-on-container-exit
#podman build -f centos_build/Dockerfile.fedora33 -t naemon .
buildah bud \
    --layers --jobs $JOBS \
    --volume $(pwd)/RPM_CACHE:/RPM_CACHE:rw,Z \
    -f centos_build/Dockerfile.fedora33 -t adagios-fedora .
