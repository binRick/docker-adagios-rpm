#!/bin/bash

cmd="exec bwrap --ro-bind /usr /usr \
       --dir /tmp \
       --proc /proc \
       --dev /dev \
       --ro-bind /etc/resolv.conf /etc/resolv.conf \
       --symlink usr/lib /lib \
       --symlink usr/lib64 /lib64 \
       --symlink usr/bin /bin \
       --symlink usr/sbin /sbin \
       --chdir / \
       --unshare-pid \
       --dir /run/user/$(id -u) \
       --setenv XDG_RUNTIME_DIR '/run/user/$(id -u)' \
       $@"

eval $cmd
