#!/bin/bash
NEW_KEY_FILE=".${MY_CONTAINER_1_UUID}.key"
set -e
source setup.sh

container_hostname="$MY_CONTAINER_1_UUID"
CPUS_QTY=1
image_volume=ignore
image_volume=tmpfs
image_volume=bind
privileged=true
shm_size=64m
blkio_weight=500   #  10 - 1000
kernel_memory=400m
memory=1512m
memory_plus_swap_limit=2524m
memory_swappiness=50  #  0 - 100
oom_score_adj=0       #  -1000 - 1000
pids_limit=500
add_host_ip="yahoo.com:1.2.3.4"

set +e
start_pod.sh
set -e

ls_container.sh >/dev/null && exit 1


start_named_container_from_image_in_pod(){
  CONTAINER_NAME="$1"
  IMAGE_NAME="$2"
  POD_NAME="$3"

  cmd="sudo podman run \
    --env CONTAINER_UUID='$MY_CONTAINER_1_UUID' \
    --cpus='$CPUS_QTY' \
    --shm-size='$shm_size' \
    --http-proxy=false \
    --interactive=false \
    --kernel-memory='$kernel_memory' \
    --memory='$memory' \
    --memory-swap='$memory_plus_swap_limit' \
    --memory-swappiness='$memory_swappiness' \
    --image-volume='$image_volume' \
    --hostname='$container_hostname' \
    --name='$CONTAINER_NAME' \
    --oom-kill-disable=false \
    --pids-limit='$pids_limit' \
    --oom-score-adj='$oom_score_adj' \
    --label 'com.example.key=value' \
    --security-opt label=type:spc_t \
    --privileged='$privileged' \
    --restart=always \
    --pod='$POD_NAME' \
    --tmpfs /tmp \
    --cap-add=SYS_ADMIN \
    --blkio-weight='$blkio_weight' \
    --add-host='$add_host_ip' \
    --userns=keep-id \
    --env-host=false \
    --read-only=false \
    -v '/sys/fs/cgroup:/sys/fs/cgroup:ro' \
    -d '$IMAGE_NAME'"

    eval $cmd
}


start_named_container_from_image_in_pod "$MY_CONTAINER_1_UUID" "$MY_CONTAINER_1_IMAGE_UUID" "$MY_POD_UUID"

sleep 1
iptables.sh

#sleep 1
#curl.sh

sleep 1
thruk_rest_api.sh
set +e

generate_new_key.sh > $NEW_KEY_FILE








