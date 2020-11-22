set -ex


./stop_pod.sh

cmd="sudo podman pod exists $MY_POD_UUID && sudo podman pod rm $MY_POD_UUID"

eval $cmd

set +ex
