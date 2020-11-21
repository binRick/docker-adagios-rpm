PORT=7125

cmd="sudo podman run \
    --security-opt label=type:spc_t \
    --privileged=true \
    --rm --name adagios -p $PORT:80 -d adagios_systemd_image"

#    --tmpfs /tmp \
#    --userns=keep-id \
eval $cmd
