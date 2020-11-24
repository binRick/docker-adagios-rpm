#!/bin/bash
set -e
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

(cd ../ && render_templates.sh)

podman-compose \
    -t 1podfw \
    -f docker-compose.yaml up

