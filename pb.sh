#!/bin/bash
set -e

pip3 install ansible --upgrade --user -q

cd ansible-role-podman
ansible-galaxy install -r ansible-galaxy-requirements.yml
cd ../

ansible-playbook  -i localhost, pb.yaml -v

which podman
podman --version
systemctl is-enabled podman || systemctl enable podman
systemctl is-active podman | grep ^active || systemctl start podman
systemctl status podman

ln -s $(which podman) /bin/.
