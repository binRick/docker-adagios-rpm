#!/bin/bash
set -e
CENTOS_VERSION="${1:-7}"
YUM_DIR="/var/cache/centos/$CENTOS_VERSION/yum"
DNF_DIR="/var/cache/centos/$CENTOS_VERSION/dnf"
RPM_DIR="/var/cache/centos/$CENTOS_VERSION/rpms"
YUM_CACHE="/var/cache/yum"
DNF_CACHE="/var/cache/dnf"
RPM_CACHE="/var/cache/rpms"
WRITABLE_VOLUMES="-v ${YUM_DIR}:${YUM_CACHE}:z -v ${DNF_DIR}:${DNF_CACHE}:z -v ${RPM_DIR}:${RPM_CACHE}:z"
READABLE_VOLUMES="-v $YUM_DIR:$YUM_CACHE:z -v $DNF_DIR:$DNF_CACHE:z -v $RPM_DIR:$RPM_CACHE:z"
IMAGE="centos:$CENTOS_VERSION"

sudo mkdir -p $YUM_DIR $DNF_DIR $RPM_DIR

cmd="echo -ne 'RPMs: '; sudo podman run --rm $WRITABLE_VOLUMES -it $IMAGE rpm -qa|wc -l"
eval $cmd

cmd="sudo podman run --rm $WRITABLE_VOLUMES -it $IMAGE yum -y install dnf"
eval $cmd

cmd="sudo podman run --rm $WRITABLE_VOLUMES -it $IMAGE yum makecache"
eval $cmd

cmd="sudo podman run --rm $WRITABLE_VOLUMES -it $IMAGE dnf makecache"
eval $cmd


sudo podman run --rm $WRITABLE_VOLUMES -ti $IMAGE yum -y makecache
sudo podman run --rm $WRITABLE_VOLUMES -ti $IMAGE dnf -y makecache

exit
#time sudo podman build \
#    -v /var/cache/centos/yum/7:/var/cache/yum:O \
#        -f Dockerfile_centos_7_yum_update

time sudo podman build \
    -v /var/cache/centos/dnf/8:/var/cache/dnf:z \
    -v /var/cache/repos/centos/dnf/8:/var/cache/repo:z \
        -f Dockerfile_centos_8_yum_update

#time sudo podman run --rm \
#    -v /var/cache/repos/centos/dnf/8:/var/cache/repo \
#    -ti centos:8 \
#        dnf -y reinstall --downloadonly --destdir /var/cache/repo haproxy


sudo podman run --rm -v $(pwd)/customrepo.repo:/customrepo.repo -v /var/cache/repos/centos/dnf/8:/var/cache/repo -ti centos:8 dnf -y --repofrompath local,file:///customrepo.repo  --repo local --nogpgcheck \
    install tcpdump git nmap-ncat


set +x
find /var/cache/centos/yum/7|wc -l
find /var/cache/centos/dnf/8|wc -l
find /var/cache/repos/centos/dnf/8|wc -l
du --max-depth=1 -h /var/cache/repos/centos/dnf/8
set -x
