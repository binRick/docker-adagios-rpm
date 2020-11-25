#!/bin/bash
set +e
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ARGS="$@"
PROJECT_NAME=$MY_POD_UUID
CONTAINER_NAME=${PROJECT_NAME}_${MY_CONTAINER_1_UUID}_1

pod_exists(){
  podman pod exists $PROJECT_NAME
}
container_exists(){
  podman container exists $CONTAINER_NAME
}




ensure_down(){
 (
  set +ex
  podman container exists $CONTAINER_NAME && podman kill $CONTAINER_NAME
  podman container exists $CONTAINER_NAME && podman rm $CONTAINER_NAME
  podman pod exists $PROJECT_NAME && podman pod rm $PROJECT_NAME
  podman container exists $CONTAINER_NAME && podman kill $CONTAINER_NAME
  podman container exists $CONTAINER_NAME && podman rm $CONTAINER_NAME
  podman pod exists $PROJECT_NAME && podman pod rm $PROJECT_NAME
  true
  set -ex
 ) 2>/dev/null
}

trap ensure_down EXIT

ensure_down

podman-compose -f container-compose.yaml down

#../podman_scripts/rm_pods.sh
#../podman_scripts/rm_all.sh
