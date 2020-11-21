./render_templates.sh
time sudo podman build -t adagios_systemd_image_base -f .Dockerfile.base $@

