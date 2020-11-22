set -e
eval $(cat setup.sh)
./render_templates.sh

time sudo podman build -t adagios_systemd_image -f .Dockerfile 

set +e
