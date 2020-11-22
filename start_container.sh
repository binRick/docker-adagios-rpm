
set -e

./start_pod.sh

./ls_container.sh >/dev/null && exit 1

cmd="sudo podman run \
    --name '$MY_CONTAINER_1_UUID' \
    --security-opt label=type:spc_t \
    --privileged=true \
    --restart=always \
    --pod='$MY_POD_UUID' \
    --tmpfs /tmp \
    --cap-add=SYS_ADMIN \
    -v /sys/fs/cgroup:/sys/fs/cgroup \
    -d '$MY_CONTAINER_1_IMAGE_UUID'"

#    --userns=keep-id \
eval $cmd

#sleep 1
#./iptables.sh

#sleep 1
#./curl.sh

./thruk_rest_api.sh
set +e
