#!/bin/bash
set -e

cmd="./exec_container.sh tcpdump -nvvvvv $@"
eval $cmd
