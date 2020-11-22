set -ex

my_pod=$MY_UUID

cmd="sudo podman pod exists $my_pod && sudo podman pod stop $my_pod"

eval $cmd

set +ex
