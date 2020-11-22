set -ex

my_pod=$MY_UUID


cmd="sudo podman pod exists $my_pod && sudo podman pod start $my_pod && exit 0"
#eval $cmd

cmd="sudo podman pod create \
    --name $my_pod \
    -p ${MY_INDEX}$DEV_PORT_1:$DEV_PORT_1 \
    -p ${MY_INDEX}$DEV_PORT_2:$DEV_PORT_2 \
"
eval $cmd

set +ex
