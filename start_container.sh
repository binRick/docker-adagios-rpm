PORT=7125

cmd="sudo podman run \
    --name adagios \
    --security-opt label=type:spc_t \
    --privileged=true \
    --rm \
    -p $PORT:80 \
    -p 5000:5000 \
    -p 5001:5001 \
    -d adagios_systemd_image"

#    --tmpfs /tmp \
#    --userns=keep-id \
eval $cmd

sleep 1
./iptables.sh

sleep 1
./curl.sh
