#!/usr/bin/env bash
set -e

cmd="./server.sh $@"
killall node||true
$(command -v nodemon) -w . -e sh,yaml,j2,json,py -V --delay .5 -x "$cmd"
