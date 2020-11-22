set -ex

my_pod=$MY_UUID



cmd="sudo podman pod create \
    --name $my_pod \
    -p $MY_ADAGIOS_PORT:$INTERNAL_ADAGIOS_PORT \
"
./ls_pod.sh || eval $cmd

set +ex
