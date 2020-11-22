#!/bin/bash
set -e

secret_key_file=.secret-${MY_CONTAINER_1_UUID}.key

get_secret_key(){
    sudo podman cp $MY_CONTAINER_1_UUID:/var/lib/thruk/secret.key $secret_key_file && sudo chown root:root $secret_key_file && sudo chmod 600 $secret_key_file && sudo cat $secret_key_file && sudo unlink $secret_key_file
}



get_secret_key
