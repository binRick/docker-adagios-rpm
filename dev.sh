#!/usr/bin/env bash
set -e

cmd="./build_image.sh $@"
killall node||true
$(command -v nodemon) -w Dockerfile -w . -e sh,yaml,j2,json,cfg,py -V --delay .5 -x "$cmd"
