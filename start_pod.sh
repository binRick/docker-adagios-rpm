set -ex




cmd="sudo podman pod create \
    --name $MY_POD_UUID \
    -p $MY_ADAGIOS_PORT:$INTERNAL_ADAGIOS_PORT \
"
eval $cmd

set +ex
