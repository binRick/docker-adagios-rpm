SHELL=zsh

cmd="sudo podman exec -it $MY_CONTAINER_1_UUID $SHELL"

eval $cmd
