#!/bin/bash
set -e
[[ -f /opt/borg/bin/activate ]] || virtualenv --python=python3 /opt/borg
source /opt/borg/bin/activate
pip install borgbackup --upgrade

/opt/borg/bin/borg --version

deactivate

/opt/borg/bin/borg --version


sh -ilc '/opt/borg/bin/borg --version'

[[ -f /usr/local/bin/borg ]] && unlink /usr/local/bin/borg

ln -s /opt/borg/bin/borg /usr/local/bin/borg

command -v borg
borg --version
