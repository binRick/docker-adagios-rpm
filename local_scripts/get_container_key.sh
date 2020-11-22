#!/bin/bash
set -e

get_secret_key(){
    sudo podman cp $(sudo podman ps -q):/var/lib/thruk/secret.key . && sudo chmod 755 secret.key && cat secret.key && unlink secret.key
}

get_secret_key
