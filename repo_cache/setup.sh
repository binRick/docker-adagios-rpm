#!/bin/bash
set -e
sudo mkdir -p \
    /var/cache/centos/yum/7 \
    /var/cache/centos/yum/8 \
    /var/cache/centos/dnf/7 \
    /var/cache/centos/dnf/8 


sudo podman run -v /var/cache/centos/yum/7:/var/cache/yum:z -ti centos:7 yum makecache
sudo podman run -v /var/cache/centos/yum/8:/var/cache/yum:z -ti centos:8 yum makecache

time sudo podman build -v /var/cache/centos/yum/7:/var/cache/yum:O -f Dockerfile_centos_7_yum_update
time sudo podman build -v /var/cache/centos/yum/8:/var/cache/yum:O -f Dockerfile_centos_8_yum_update



sudo podman run -v /var/cache/centos/dnf/8:/var/cache/dnf:z -ti centos:8 dnf -y makecache



set +x
find /var/cache/centos/yum/7|wc -l
find /var/cache/centos/dnf/8|wc -l
set -x
