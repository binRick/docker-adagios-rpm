#!/bin/bash
set -ex

cat .envrc.enc.base64 | base64 -d > .envrc.enc
safeu --decrypt .envrc.enc --output .envrc

md5sum .envrc*
ls -altr .envrc*
file .envrc| grep ': data$' -q && { echo Invalid; unlink .envrc; exit 1; }


direnv allow .
