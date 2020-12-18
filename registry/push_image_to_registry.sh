#!/bin/bash
set -ex
set +e
podman login -u registryuser -p registryuserpassword --tls-verify=false localhost:5009

set -x

IMG=vpntech-haproxy-container_haproxy
SRC_IMAGE=localhost/$IMG
DST_IMAGE=haproxy-centos-8
podman tag $SRC_IMAGE localhost:5009/$DST_IMAGE
podman push localhost:5009/$DST_IMAGE --tls-verify=false



IMG=nagios-02a53693_centos_7
DST_IMAGE=nagios-centos-7
SRC_IMAGE=localhost/$IMG
podman tag $SRC_IMAGE localhost:5009/$DST_IMAGE
podman push localhost:5009/$DST_IMAGE --tls-verify=false
