#!/bin/bash
set -ex

safeu --encrypt .envrc.enc --output .envrc.enc
cat .envrc.enc | base64  > .envrc.enc.base64
md5sum .envrc*
ls -altr .envrc*
