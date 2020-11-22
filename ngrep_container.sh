#!/bin/bash
set -e
cmd="./exec_container.sh ngrep -qWbyline $@"
eval $cmd
