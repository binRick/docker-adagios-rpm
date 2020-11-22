set -e


cmd="sudo podman network inspect podman|jq"

eval $cmd

set +e
