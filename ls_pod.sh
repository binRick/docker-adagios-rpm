#!/bin/bash
set -ex
PORT=7125

my_pod=$MY_UUID

cmd="sudo podman pod ls|grep -q ${MY_UUID}"

eval $cmd

