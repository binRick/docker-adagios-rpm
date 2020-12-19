#!/bin/bash
PROJECT_NAME=naemon
JOBS=4

set +e
podman-compose -f container-adagios-compose.yaml down 2>/dev/null

set -e
#podman-compose -p $PROJECT_NAME -f container-adagios-compose.yaml up --build --abort-on-container-exit
#podman build -f centos_build/Dockerfile.fedora33 -t naemon .
buildah bud --layers --jobs $JOBS -f centos_build/Dockerfile.fedora33 -t adagios-fedora .
