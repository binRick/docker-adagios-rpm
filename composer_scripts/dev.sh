#!/bin/bash
set -e
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cmd=./down_up.sh
cmd="nodemon -w . -e yaml -V --delay .5 -x '$cmd'"

eval $cmd
