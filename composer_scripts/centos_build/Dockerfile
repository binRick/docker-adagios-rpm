ARG CENTOS_VERSION=7

FROM centos:${CENTOS_VERSION} as phase_1



RUN touch /1
RUN echo $gitcommithash > /DEBUG.txt

RUN sed -i 's/^installonly_limit=3/installonly_limit=60/g' /etc/yum.conf
# First install the opensource.is and consol labs repositories

# Redhat/Centos users need to install the epel repositories (fedora users skip this step)
RUN yum install -y epel-release dnf

RUN sed -i 's/^installonly_limit=3/installonly_limit=60/g' /etc/dnf/dnf.conf
RUN dnf clean all && dnf -y update


from phase_1 as centos_2

# DNF
RUN dnf -y install \
	gcc-c++ rrdtool perl-Time-HiRes perl-rrdtool php-gd php php-cli wget mlocate \
	git postfix python-pip python3-pip python3-devel python-devel acl python-setuptools \
	zsh telnet openssh-server ansible-python3 openvpn openvpn-devel rpm-build tinyproxy nodejs \
    haproxy jq chrony rng-tools automake cmake gcc tcpdump ngrep bind-utils nmap-ncat at tar npm \
    fail2ban certbot tree redis tmux ngrep make automake net-tools



# Remove yum cache
from phase_2 as phase_3
RUN yum clean all -y && rm -rf /var/cache/yum


RUN sh -c 'dnf list > /root/.dnf'

CMD ["/usr/sbin/init"]
