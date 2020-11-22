#!/bin/bash
set -ex
PORT=7125

my_pod=$MY_UUID

./stop_pod.sh

cmd="sudo podman pod exists $my_pod && sudo podman pod rm $my_pod"

eval $cmd

