#!/bin/bash
set -e
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cmd='sh -c "podman-compose -f docker-compose.yaml build"'

eval $cmd
