#!/bin/bash
set -e
source setup.sh

pip install pip --upgrade
pip install \
	'j2cli[yaml]' \
	'podman-compose' \
--upgrade

id | grep -q root || sudo -u root pip3 install \
	'podman-compose' \
--upgrade --user

sudo dnf -y remove docker docker-common
sudo dnf -y install podman
