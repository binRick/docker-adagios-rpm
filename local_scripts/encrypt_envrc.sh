#!/bin/bash
set -ex

safeu --encrypt .envrc --output .envrc.enc
cat .envrc.enc | base64  > .envrc.enc.base64
md5sum .envrc*
ls -altr .envrc*


file .envrc | grep -q ASCII || exit 1

cat .envrc|md5sum|cut -d' ' -f1 > .envrc.md5sum

git commit .envrc.md5sum .envrc.enc.base64 -m 'env updated'
git push
