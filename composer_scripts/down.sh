#!/bin/bash
set +e
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )



podman-compose -f docker-compose.yaml down

../podman_scripts/rm_pods.sh
../podman_scripts/rm_all.sh
