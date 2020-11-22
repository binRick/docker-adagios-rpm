set -ex


cmd="sudo podman pod exists $MY_POD_UUID && sudo podman pod stop $MY_POD_UUID"

eval $cmd

set +ex
