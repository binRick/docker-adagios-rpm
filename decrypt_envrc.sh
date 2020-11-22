#!/bin/bash
set -ex

cat .envrc.env.base64 | base64 -d > .envrc.enc
safeu --decrypt .envrc.enc --output .envrc && direnv allow .
md5sum .envrc*
ls -altr .envrc*
