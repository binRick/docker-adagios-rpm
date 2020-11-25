#!/bin/bash
set -e

pip3 install ansible --upgrade --user -q

cd ansible-role-podman
ansible-galaxy install -r ansible-galaxy-requirements.yml
