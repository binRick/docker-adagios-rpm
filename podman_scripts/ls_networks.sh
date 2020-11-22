set -e


cmd="sudo podman network inspect podman"

eval $cmd

set +e
