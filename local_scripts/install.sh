#!/bin/bash
set -e
source setup.sh

pip install pip --upgrade
pip install \
	'j2cli[yaml]' \
	'https://github.com/containers/podman-compose/archive/devel.tar.gz' \
	'podman' \
	'json2yaml' \
--upgrade

id | grep -q ^root$ || sudo -u root pip3 install \
	'j2cli[yaml]' \
	'https://github.com/containers/podman-compose/archive/devel.tar.gz' \
    'podman' \
	'json2yaml' \
--upgrade --user

sudo dnf -y remove docker docker-common
sudo dnf -y install podman iptables podman-remote podman-docker
systemctl enable io.podman
systemctl start io.podman
systemctl status io.podman
