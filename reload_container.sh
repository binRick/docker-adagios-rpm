set -ex

./kill_container.sh || true

./stop_pod.sh

#./rm_all.sh

./start_container.sh

set +ex
