FROM ubuntu:18.04

RUN apt-get update -qq \
    && apt-get install -qq -y software-properties-common uidmap \
    && add-apt-repository -y ppa:projectatomic/ppa \
    && apt-get update -qq \
    && apt-get -qq -y install podman \
    && apt-get install -y iptables

RUN adduser --disabled-login --gecos test test

USER test

ENTRYPOINT ["podman", "--storage-driver=vfs"]
CMD ["info"]
