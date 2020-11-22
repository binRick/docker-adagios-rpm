
set -ex


set +x
./start_pod.sh
set -x



cmd="sudo podman run \
    --name '$MY_CONTAINER_1_UUID' \
    --security-opt label=type:spc_t \
    --privileged=true \
    --restart=always \
    --pod=$MY_POD_UUID \
    --tmpfs /tmp \
    -d adagios_systemd_image"

#    --userns=keep-id \
#    -p $PORT:80 \
#    -p 5000:5000 \
#    -p 5001:5001 \
eval $cmd

sleep 1
./iptables.sh

sleep 1
./curl.sh

#./thruk_rest_api.sh
set +ex
