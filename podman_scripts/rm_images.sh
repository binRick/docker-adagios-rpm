set -ex

kill_containers.sh

sudo podman images -q | xargs -I % sudo podman image rm %
set +ex
