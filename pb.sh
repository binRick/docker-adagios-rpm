#!/bin/bash
set -e

pip3 install ansible --upgrade --user -q

cd ansible-role-podman
ansible-galaxy install -r ansible-galaxy-requirements.yml

ansible-playbook  -i localhost, pb.yaml -v

which podman
podman --version
systemctl status podman
systemctl is-enabled podman || systemctl enable podman --now

