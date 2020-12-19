#!/bin/bash
PROJECT_NAME=naemon
JOBS=10
bold=$(tput bold)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
cyan=$(tput setaf 6)
reset=$(tput sgr0)

echo -e "Building an image called ${PROJECT_NAME}"

[[ ! -d RPM_CACHE ]] && mkdir RPM_CACHE

stat -c %T -f /sys/fs/cgroup

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

echo -e "${green}Build are done!${reset}"

buildah images

podman-compose -f container-adagios-compose.yaml  up --no-build --force-recreate

