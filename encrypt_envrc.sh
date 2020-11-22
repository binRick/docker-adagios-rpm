#!/bin/bash
set -ex

safeu --encrypt .envrc --output .envrc.enc
cat .envrc.enc | base64  > .envrc.enc.base64
md5sum .envrc*
ls -altr .envrc*


file .envrc | grep -q ASCII || exit 1

git commit .envrc -m 'env updated'
git push
