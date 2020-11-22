#!/bin/bash
NEW_KEY_FILE=".${MY_CONTAINER_1_UUID}.key"
set -e
source setup.sh

container_hostname="$MY_CONTAINER_1_UUID"

./start_pod.sh

./ls_container.sh >/dev/null && exit 1


start_named_container_from_image_in_pod(){
  CONTAINER_NAME="$1"
  IMAGE_NAME="$2"
  POD_NAME="$3"

  cmd="sudo podman run \
    --env CONTAINER_UUID='$MY_CONTAINER_1_UUID' \
    --shm-size=2048m \
    --hostname '$container_hostname' \
    --name '$CONTAINER_NAME' \
    --security-opt label=type:spc_t \
    --privileged=true \
    --restart=always \
    --pod='$POD_NAME' \
    --tmpfs /tmp \
    --cap-add=SYS_ADMIN \
    --userns=keep-id \
    -v '/sys/fs/cgroup:/sys/fs/cgroup:ro' \
    -d '$IMAGE_NAME'"

    eval $cmd
}
#    -v /sys/fs/cgroup:/sys/fs/cgroup \


start_named_container_from_image_in_pod "$MY_CONTAINER_1_UUID" "$MY_CONTAINER_1_IMAGE_UUID" "$MY_POD_UUID"








sleep 1
./iptables.sh

#sleep 1
#./curl.sh








sleep 1
./thruk_rest_api.sh
set +e

./generate_new_key.sh > $NEW_KEY_FILE
