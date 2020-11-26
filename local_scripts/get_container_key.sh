#!/bin/bash
set -e

PROJECT_NAME=$MY_POD_UUID
CONTAINER_NAME=${PROJECT_NAME}_${NAGIOS_CONTAINER_NAME}_1

secret_key_file=.secret-${CONTAINER_NAME}.key

get_secret_key(){
    sudo podman cp $CONTAINER_NAME:/var/lib/thruk/secret.key $secret_key_file && sudo chown root:root $secret_key_file && sudo chmod 600 $secret_key_file && sudo cat $secret_key_file && sudo unlink $secret_key_file
}



get_secret_key
