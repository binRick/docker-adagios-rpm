#!/bin/bash
set -e
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
git submodule update --remote --merge


dnf -y remove podman\*

[[ ! -d .venv ]] && python3 -m venv .venv 
source .venv/bin/activate

pip3 install ansible --upgrade -q

cd ansible-role-podman
ansible-galaxy install -r ansible-galaxy-requirements.yml
cd ../

ansible-playbook  -i localhost, pb.yaml -v

which podman
podman --version
systemctl is-enabled podman || systemctl enable podman
systemctl is-active podman | grep ^active || systemctl start podman
systemctl status podman

