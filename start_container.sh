
set -e

./start_pod.sh


cmd="sudo podman run \
    --name '$MY_CONTAINER_1_UUID' \
    --security-opt label=type:spc_t \
    --privileged=true \
    --restart=always \
    --pod='$MY_POD_UUID' \
    --tmpfs /tmp \
    -d adagios_systemd_image"

#    --userns=keep-id \
eval $cmd

#sleep 1
#./iptables.sh

#sleep 1
#./curl.sh

./thruk_rest_api.sh
set +e
