#!/bin/bash
PROJECT_NAME=naemon
JOBS=4
[[ ! -d RPM_CACHE ]] && mkdir RPM_CACHE

set +e
podman-compose -f container-adagios-compose.yaml down 2>/dev/null

set -e
#podman-compose -p $PROJECT_NAME -f container-adagios-compose.yaml up --build --abort-on-container-exit
#podman build -f centos_build/Dockerfile.fedora33 -t naemon .
[[ ! -f check-mk-raw-1.6.0p19.cre.tar.gz ]] && wget https://checkmk.com/support/1.6.0p19/check-mk-raw-1.6.0p19.cre.tar.gz
du --max-depth=1 -h RPM_CACHE/

buildah bud \
    --layers --jobs $JOBS \
    --volume $(pwd)/RPM_CACHE:/var/cache/dnf:rw,Z \
    -f centos_build/Dockerfile.fedora33 -t adagios-fedora .
