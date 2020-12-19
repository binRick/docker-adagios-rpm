#!/bin/bash
PROJECT_NAME=naemon
bold=$(tput bold)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
cyan=$(tput setaf 6)
reset=$(tput sgr0)

if [[ "$1" == "squash" ]]; then
  SQUASH="--squash"
else
  SQUASH=""
fi
JOBS=5

echo -e "Building an image called ${PROJECT_NAME}"
[[ ! -d RPM_CACHE ]] && mkdir RPM_CACHE
[[ ! -d /repo ]] && mkdir /repo

stat -c %T -f /sys/fs/cgroup

set +e
podman-compose -f container-adagios-compose.yaml down 2>/dev/null

set -e
#podman-compose -p $PROJECT_NAME -f container-adagios-compose.yaml up --build --abort-on-container-exit
#podman build -f centos_build/Dockerfile.fedora33 -t naemon .
#[[ ! -f check-mk-raw-1.6.0p19.cre.tar.gz ]] && wget https://checkmk.com/support/1.6.0p19/check-mk-raw-1.6.0p19.cre.tar.gz
du --max-depth=1 -h RPM_CACHE/
du --max-depth=1 -h /repo

buildah bud \
    $SQUASH \
    --jobs $JOBS \
    --volume $(pwd)/RPM_CACHE:/var/cache/dnf:rw,Z \
    --volume /repo:/repo:ro,Z \
    -f centos_build/Dockerfile.fedora33 \
    -t adagios-fedora .

echo -e "${green}Image Build is done!${reset}"

buildah images

#		--project-name $PROJECT_NAME \
podman-compose \
		-f container-adagios-compose.yaml up \
							--no-build --force-recreate --detach

podman exec nagios_adagios-fedora_1 ps axfuw

podman exec -it nagios_adagios-fedora_1 bash
