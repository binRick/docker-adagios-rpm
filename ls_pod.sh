#!/bin/bash
set -ex
PORT=7125

cmd="sudo podman pod ls|grep -q ${MY_POD_UUID}"

eval $cmd

