#!/bin/bash
set -ex


podman login -u registryuser -p registryuserpassword --tls-verify=false localhost:5009

set -x

SRC_IMAGE=localhost/nagios-02a53693_centos_7_base_rpms
DST_IMAGE=nagios-02a53693_centos_7_base_rpms

podman tag $SRC_IMAGE localhost:5009/$DST_IMAGE

podman push localhost:5009/$DST_IMAGE --tls-verify=false



