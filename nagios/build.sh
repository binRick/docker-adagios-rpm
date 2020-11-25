#!/bin/bash
set -e
EXEC_PATH="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
EXEC_SCRIPT="$(basename $BASH_SOURCE)"
EXEC_ARGS="$@"
PROJECT_NAME=$MY_POD_UUID
CONTAINER_NAME=${PROJECT_NAME}_${MY_CONTAINER_1_UUID}

cd $EXEC_PATH

cat container-compose.yaml|yaml2json 2>/dev/null |json2yaml >/dev/null

cd ../
#render_templates.sh
cd $EXEC_PATH

#. ./re_exec_as_root.sh


cmd="podman-compose -f container-compose.yaml \
         --project-name $PROJECT_NAME \
            build \
    "

eval $cmd
