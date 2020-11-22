#set -e
set +e
cmd="sudo podman pod ls --ctr-names |grep ' $MY_POD_UUID '"

eval $cmd

#set +e
