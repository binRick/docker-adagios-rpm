
kill_containers.sh
set -ex

sudo podman images -q | xargs -I % sudo podman image rm %
set +ex
