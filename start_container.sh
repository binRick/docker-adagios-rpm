PORT=7125

sudo podman run --rm --name adagios -p $PORT:80 -d adagios_systemd_image
