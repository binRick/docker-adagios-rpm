FROM centos:7

RUN sed -i 's/^installonly_limit=3/installonly_limit=60/g' /etc/yum.conf
# First install the opensource.is and consol labs repositories

# Redhat/Centos users need to install the epel repositories (fedora users skip this step)
RUN yum install -y epel-release dnf

RUN sed -i 's/^installonly_limit=3/installonly_limit=60/g' /etc/dnf/dnf.conf
RUN dnf clean all && dnf -y update

COPY files/ok-release.rpm /usr/src
COPY files/labs-consol-stable.rhel7.noarch.rpm /usr/src
RUN dnf -y install /usr/src/ok-release.rpm /usr/src/labs-consol-stable.rhel7.noarch.rpm
RUN unlink /usr/src/labs-consol-stable.rhel7.noarch.rpm
RUN unlink /usr/src/ok-release.rpm

# DNF
RUN dnf -y install \
	gcc-c++ rrdtool perl-Time-HiRes perl-rrdtool php-gd php php-cli wget mlocate \
	git postfix python-pip python3-pip python3-devel python-devel acl python-setuptools \
	zsh telnet openssh-server ansible-python3 openvpn openvpn-devel rpm-build tinyproxy nodejs \
    haproxy jq chrony rng-tools automake cmake gcc tcpdump ngrep bind-utils nmap-ncat at tar npm \
    fail2ban certbot tree naemon-devel redis tmux ngrep make automake net-tools \
    nagios-plugins-tcp nagios-plugins-http nagios-plugins-users nagios-plugins-smtp nagios-plugins-procs nagios-plugins-mysql \
    nagios-plugins-mailq nagios-plugins-load nagios-plugins-dns nagios-plugins-dig nagios-plugins-disk nagios-plugins-ssh \
    nagios-plugins-ping nagios-plugins-http nagios-plugins-fping nagios-plugins-by_ssh nagios-plugins-check_cpu nagios-plugins-file_age \
    nagios-plugins-icmp nagios-plugins-nagios nagios-plugins-time nagios-plugins-swap \
    strace sqlite-devel jansson-devel mariadb-devel which go vim lsof psmisc aide sysstat chkconfig bubblewrap dstat socat \
    nagios-okplugin-check_firewall_active nagios-okplugin-check_package_updates nagios-okplugin-check_ifoperstate \
    nagios-okplugin-get_network_stat nagios-okplugin-check_disks perl-Net-DNS nagios-okplugin-check_http_multi \
    python2-speedtest-cli perl-Monitoring-Plugin perl-Switch man-db python-virtualenv libacl-devel keepalived



COPY rpms/daemontools-encore-1.11-1.el7.x86_64.rpm /usr/src
COPY files/ncpa-2.2.2.el7.x86_64.rpm /usr/src
RUN dnf -y install /usr/src/ncpa-2.2.2.el7.x86_64.rpm;\ 
    dnf -y install /usr/src/daemontools-encore-1.11-1.el7.x86_64.rpm;\
    unlink /usr/src/ncpa-2.2.2.el7.x86_64.rpm;\
    unlink /usr/src/daemontools-encore-1.11-1.el7.x86_64.rpm

RUN yum --enablerepo=ok-testing install -y naemon naemon-livestatus adagios okconfig pnp4nagios


# Remove yum cache
RUN yum clean all -y && rm -rf /var/cache/yum


RUN sh -c 'dnf list > /root/.dnf'
