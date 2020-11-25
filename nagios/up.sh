#!/bin/bash
set -e
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

#trap ensure_down EXIT

echo CONTAINER_NAME=$CONTAINER_NAME

#(cd ../ && render_templates.sh)

ensure_down
cmd="-f container-compose.yaml \
     --project-name $PROJECT_NAME \
     up \
     --no-build \
     --detach \
     --exit-code-from $MY_CONTAINER_1_UUID \
     --abort-on-container-exit $ARGS"

eval podman-compose $cmd

sleep 1

thruk_rest_api.sh

backup_configs.sh

summary.sh
