#!/bin/bash
PORT=7125

my_pod=$MY_UUID


cmd="sudo podman pod exists $my_pod && sudo podman pod start $my_pod && exit 0"
eval $cmd

cmd="sudo podman pod create \
    --name $my_pod \
    -p 8080:80\
"
eval $cmd

