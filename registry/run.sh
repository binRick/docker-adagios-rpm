#!/bin/bash
set -ex

mkdir -p /opt/registry/{auth,certs,data}
htpasswd -bBc /opt/registry/auth/htpasswd registryuser registryuserpassword


podman run --name myregistry \
     --privileged \
    -p 5009:5000 \
    -v /opt/registry/data:/var/lib/registry:z \
    -v /opt/registry/auth:/auth:z \
    -e "REGISTRY_AUTH=htpasswd" \
    -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
    -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
    -v /opt/registry/certs:/certs:z \
    -e "REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt" \
    -e "REGISTRY_HTTP_TLS_KEY=/certs/domain.key" \
    -e REGISTRY_COMPATIBILITY_SCHEMA1_ENABLED=true \
    --rm \
    docker.io/library/registry:latest


sleep .1

podman login -u registryuser -p registryuserpassword --tls-verify=false localhost:5009

#sudo podman pull registry.access.redhat.com/ubi8/ubi:latest
#podman tag registry.access.redhat.com/ubi8/ubi:latest localhost:5009/ubi8/ubi:latest
#podman push localhost:5009/ubi8/ubi:latest --tls-verify=false



