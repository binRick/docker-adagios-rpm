set -ex

kill_containers.sh || true

stop_pod.sh

#rm_all.sh

start_container.sh

set +ex
