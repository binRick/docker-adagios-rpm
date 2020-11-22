set -e
eval $(cat setup.sh)

./render_templates.sh
time sudo podman build -t $MY_CONTAINER_1_IMAGE_UUID -f .Dockerfile.base $@


podman cp $MY_CONTAINER_1_IMAGE_UUID:/opt/borg.tar.gz .

set +e
