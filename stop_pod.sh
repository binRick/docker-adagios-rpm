#!/bin/bash
set -ex
PORT=7125

my_pod=$MY_UUID

cmd="sudo podman pod exists $my_pod && sudo podman pod stop $my_pod"

eval $cmd

