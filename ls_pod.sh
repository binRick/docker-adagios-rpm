set -e

cmd="sudo podman pod ls --ctr-names |grep -q ' $MY_POD_UUID '"

eval $cmd

set +e
