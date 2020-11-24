#!/bin/bash
set -e
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

DEV_EXECUTE_SCRIPT="${1:-down_up.sh}"

DOCKER_FILES="$(find . -type f |grep Dockerfile|xargs -I % echo -ne " -w %")"

cmd="nodemon -w . $DOCKER_FILES -e yaml -V --delay .5 -x './$DEV_EXECUTE_SCRIPT'"

eval $cmd
