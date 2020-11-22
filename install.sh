#!/bin/bash
set -e
source setup.sh

pip install \
	'j2cli[yaml]' \
--upgrade

sudo dnf -y remove docker docker-common
sudo dnf -y install podman
