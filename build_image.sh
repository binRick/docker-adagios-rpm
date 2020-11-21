#!/bin/bash
set -e
./render_templates.sh

time sudo podman build -t adagios_systemd_image -f .Dockerfile $@
