set -ex
PORT=7125

cmd="sudo podman pod ps|grep -q ' $MY_POD_UUID '"

eval $cmd

set +ex
