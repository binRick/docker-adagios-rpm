#!/bin/bash
set -ex
source setup.sh

pip install \
	'j2cli[yaml]' \
--upgrade --force

sudo dnf -y remove docker docker-common
sudo dnf -y install podman
