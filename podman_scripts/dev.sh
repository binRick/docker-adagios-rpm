#!/usr/bin/env bash
set -e
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cmd="build_image.sh $@ && reload_container.sh && echo OK"
cmd="time /bin/bash -c '$cmd'"
killall node||true
$(command -v nodemon) \
    -i configs/rendered/ \
    -i *.swp -i Dockerfile.base -w Dockerfile -w . -e sh,yaml,j2,json,cfg,py -V --delay .5 -x "$cmd"
