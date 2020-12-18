#!/bin/bash
set -e
source setup.sh
alias pip=pip3

pip install pip --upgrade
pip install \
	'pyyaml' \
	'j2cli[yaml]' \
	'https://github.com/containers/podman-compose/archive/devel.tar.gz' \
	'podman' \
	'json2yaml' \
--upgrade --force

id | grep -q ^root$ || sudo -Eu root pip3 install \
	'pyyaml' \
	'j2cli[yaml]' \
	'https://github.com/containers/podman-compose/archive/devel.tar.gz' \
    'podman' \
	'json2yaml' \
--upgrade --user --force

#sudo dnf -y remove docker docker-common libselinux-python3
#sudo dnf -y install podman iptables podman-remote podman-docker
#systemctl enable io.podman
#systemctl start io.podman
##systemctl status io.podman
