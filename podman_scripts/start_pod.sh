set -ex




cmd="sudo podman pod create \
    --name $MY_POD_UUID \
    -p $MY_ADAGIOS_PORT:$INTERNAL_ADAGIOS_PORT \
    -p $MY_HAPROXY_PORT:$INTERNAL_HAPROXY_PORT \
"
ls_pod.sh || eval $cmd

set +ex
