#!/bin/bash
set -ex


podman login -u registryuser -p registryuserpassword --tls-verify=false localhost:5009

set -x

SRC_IMAGE=

podman tag $SRC_IMAGE localhost:5009/$DST_IMAGE

podman push localhost:5009/$DST_IMAGE --tls-verify=false



