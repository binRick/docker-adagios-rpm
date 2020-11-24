#!/bin/bash
./down.sh 2>/dev/null
set -e
./build.sh
./up.sh
