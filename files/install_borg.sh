#!/bin/bash
set -e
[[ -f /opt/borg/bin/activate ]] || virtualenv --python=python3 /opt/borg
source /opt/borg/bin/activate
pip install borgbackup


