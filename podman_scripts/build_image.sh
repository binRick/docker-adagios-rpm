set -e
eval $(cat setup.sh)
render_templates.sh

time sudo podman build -t $MY_CONTAINER_1_IMAGE_UUID -f .Dockerfile 

set +e
