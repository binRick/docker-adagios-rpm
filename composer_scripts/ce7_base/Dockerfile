FROM a44f8bfa-877f-45ae-9a9b-116346a03161_rpms:latest



COPY files/install_borg.sh /root/install_borg.sh
RUN /root/install_borg.sh
RUN unlink /root/install_borg.sh

COPY files/lynis.tar.gz /opt
RUN cd /opt && tar zxf lynis.tar.gz && unlink lynis.tar.gz

COPY files/my-public-ip.tar.gz /opt
RUN cd /opt && tar zxf my-public-ip.tar.gz && unlink my-public-ip.tar.gz

#COPY monitoring-plugins.tar.gz /usr/src
#RUN git clone https://github.com/binRick/daemontools-encore-rpm /usr/src/daemontools-encore-rpm
#RUN git clone https://github.com/binRick/jo-rpm /usr/src/jo
#RUN git clone --depth 1 https://github.com/drwetter/testssl.sh.git /opt/testssl
#RUN git clone https://github.com/CISOfy/lynis /usr/src/lynis
#RUN git clone https://github.com/auzias/my-public-ip /opt/my-public-ip
#RUN git clone https://github.com/akrherz/nagios-checks.git /usr/src/nagios-checks
#RUN git clone https://github.com/centreon/centreon-plugins.git /usr/src/centreon-plugins
#RUN git clone https://github.com/HariSekhon/Nagios-Plugins.git /usr/src/Nagios-Plugins
#RUN git clone https://github.com/hobbyquaker/check_os_release.git /usr/src/check_os_release
#RUN git clone https://github.com/bebehei/check_dnsserials.git /usr/src/check_dnsserials
#RUN git clone https://github.com/seffparker/nagios-plugins.git /usr/src/nagios-plugins1
#RUN git clone https://github.com/enzote84/nagios-plugins.git /usr/src/nagios-plugins2
#RUN git clone https://github.com/ikus060/nagios-plugins.git /usr/src/nagios-plugins3
#RUN git clone https://github.com/binRick/nagios-plugins.git /usr/src/nagios-plugins4
#RUN git clone https://github.com/PagerDuty/pdagent.git  /usr/src/pdagent
#RUN git clone https://github.com/matteocorti/check_rbl.git  /usr/src/check_rbl
#RUN git clone https://github.com/bebehei/nagios-plugin-check_borg.git /usr/src/check_borg
#RUN git clone https://github.com/jrottenberg/check_rss.git  /usr/src/check_rss
#RUN git clone https://github.com/StewLG/check_static_ip.git /usr/src/check_static_ip
#RUN git clone https://github.com/matteocorti/check_nagios_latency.git   /usr/src/check_nagios_latency
#RUN wget https://github.com/madrisan/nagios-plugins-linux/releases/download/v27/nagios-plugins-linux-27.tar.bz2 -O /usr/src/nagios-plugins-linux-27.tar.bz2
#RUN sh -c 'cd /usr/src && tar jxf nagios-plugins-linux-27.tar.bz2 && cd nagios-plugins-linux-27 && ./configure --prefix=/opt/nagios-plugins-linux && make -j install'
#
#
#RUN sh -c 'cd /usr/src && tar zxf monitoring-plugins.tar.gz && cd monitoring-plugins && ./tools/setup && ./configure --prefix=/opt/monitoring-plugins && make -j && make install'
#RUN sh -c 'cd /usr/src/daemontools-encore-rpm && ./build.sh 1.11 && rpm -ivh /root/rpmbuild/RPMS/x86_64/daemontools-encore-1.11-1.el7.x86_64.rpm'
#RUN sh -c 'cd /usr/src/jo && ./build.sh 1.4 && rpm -ivh /root/rpmbuild/RPMS/x86_64/jo-1.4-1.el7.x86_64.rpm'
COPY files/naemon_plugins /etc/sudoers.d
RUN chmod 600 /etc/sudoers.d/naemon_plugins


# Systemd - preparation
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
	systemd-tmpfiles-setup.service ] || rm -f $i; done); \
	rm -f /lib/systemd/system/multi-user.target.wants/*;\
	rm -f /etc/systemd/system/*.wants/*;\
	rm -f /lib/systemd/system/local-fs.target.wants/*; \
	rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
	rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
	rm -f /lib/systemd/system/basic.target.wants/*;\
	rm -f /lib/systemd/system/anaconda.target.wants/*;
# Systemd - preparation ends

# Manual copies
COPY bin/ttyd /usr/bin
COPY bin/bwrap_exec.sh /usr/local/sbin
COPY bin/bwrap_exec_with_network.sh /usr/local/sbin

# Copy Configs
COPY configs/.profile.sh /root
COPY .haproxy.cfg /etc/haproxy/haproxy.cfg


### END SOFTWARE INSTALLS

#RUN sed -i 's|^#broker_module=.*|broker_module=/usr/lib64/naemon/naemon-livestatus/livestatus.so /var/cache/naemon/live|g' /etc/naemon/naemon.cfg;\
RUN \
    sed -i 's|^debug_level=.*|debug_level=128|g' /etc/naemon/naemon.cfg;\
    sed -i 's|^debug_verbosity=.*|debug_verbosity=2|g' /etc/naemon/naemon.cfg;\
    sed -i 's|^debug_file=.*|debug_file=/var/log/naemon/debug.log|g' /etc/naemon/naemon.cfg;\
    sed -i 's|^enable_notifications=.*|enable_notifications=0|g' /etc/naemon/naemon.cfg;\
    sed -i 's|^max_concurrent_checks=.*|max_concurrent_checks=60|g' /etc/naemon/naemon.cfg;\
    sed -i 's|^use_syslog=.*|use_syslog=0|g' /etc/naemon/naemon.cfg;\
    sed -i 's|^check_workers=.*|check_workers=2|g' /etc/naemon/naemon.cfg;\
    sed -i 's|^host_down_disable_service_checks=.*|host_down_disable_service_checks=1|g' /etc/naemon/naemon.cfg


RUN sed -i 's|^.api_keys_enabled .*|api_keys_enabled = 1|g' /etc/thruk/thruk.conf;\
    sed -i 's|^.thruk_verbose .*|thruk_verbose = 1|g' /etc/thruk/thruk.conf;\
    sed -i 's|^.basic_auth_enabled .*|basic_auth_enabled = 1|g' /etc/thruk/thruk.conf;\
    sed -i 's|^.max_api_keys_per_user .*|max_api_keys_per_user = 1000|g' /etc/thruk/thruk.conf;\
    sed -i 's|^.server_timezone .*|server_timezone = Ammerica/New_York|g' /etc/thruk/thruk.conf

RUN sed -i 's/^MinSpareServers 5/MinSpareServers 1/g' /etc/tinyproxy/tinyproxy.conf;\
    sed -i 's/^MaxSpareServers 20/MaxSpareServers 2/g' /etc/tinyproxy/tinyproxy.conf;\
    sed -i 's/^StartServers 10/StartServers 1/g' /etc/tinyproxy/tinyproxy.conf

# it is a valid git repo so we have audit trail
#RUN	git init /etc/naemon ;\
#	git config user.name "admin" ;\
#	git config user.email "admin@adagios.local" ;\
#	git add . ;\
#	git commit -a -m "Initial commit"

# Fix permissions for naemon and pnp4nagios
RUN chown -R naemon:naemon \
	/etc/naemon \
	/etc/adagios \
	/var/lib/adagios \
	/var/lib/pnp4nagios \
	/var/log/pnp4nagios \
	/var/spool/pnp4nagios \
	/etc/pnp4nagios/process_perfdata.cfg \
	/var/log/okconfig
# ACL group permissions need g+rwx
RUN	chmod g+rwx -R \
	/etc/naemon \
	/etc/adagios \
	/var/lib/adagios \
	/var/lib/pnp4nagios \
	/var/log/pnp4nagios \
	/var/spool/pnp4nagios \
	/etc/pnp4nagios/process_perfdata.cfg /var/log/okconfig

RUN	setfacl -R -m group:naemon:rwx -m d:group:naemon:rwx \
	/etc/naemon/ \
	/etc/adagios \
	/var/lib/adagios \
	/var/lib/pnp4nagios \
	/var/log/pnp4nagios \
	/var/spool/pnp4nagios \
	/etc/pnp4nagios/process_perfdata.cfg \
	/var/log/okconfig

# Make sure nagios doesn't interfere
RUN	mkdir /etc/nagios/disabled ;\
	mv /etc/nagios/{nagios,cgi}.cfg /etc/nagios/disabled/

# Make objects created by adagios go to /etc/naemon/adagios
RUN	mkdir -p /etc/naemon/adagios ;\
	pynag config --append cfg_dir=/etc/naemon/adagios

# Make adagios naemon aware
RUN sed 's|/etc/nagios/passwd|/etc/thruk/htpasswd|g' -i /etc/httpd/conf.d/adagios.conf ;\
	sed 's|user=nagios|user=naemon|g' -i /etc/httpd/conf.d/adagios.conf ;\
	sed 's|group=nagios|group=naemon|g' -i /etc/httpd/conf.d/adagios.conf ;\
	sed 's|/etc/nagios/nagios.cfg|/etc/naemon/naemon.cfg|g' -i /etc/adagios/adagios.conf ;\
	sed 's|nagios_url = "/nagios|nagios_url = "/naemon|g' -i /etc/adagios/adagios.conf ;\
	sed 's|/etc/nagios/adagios/|/etc/naemon/adagios/|g' -i /etc/adagios/adagios.conf ;\
	sed 's|/etc/init.d/nagios|/etc/init.d/naemon|g' -i /etc/adagios/adagios.conf ;\
	sed 's|nagios_service = "nagios"|nagios_service = "naemon"|g' -i /etc/adagios/adagios.conf ;\
	sed 's|livestatus_path = None|livestatus_path = "/var/cache/naemon/live"|g' -i /etc/adagios/adagios.conf ;\
	sed 's|/usr/sbin/nagios|/usr/bin/naemon|g' -i /etc/adagios/adagios.conf

# Make okconfig naemon aware
RUN sed 's|/etc/nagios/nagios.cfg|/etc/naemon/naemon.cfg|g' -i /etc/okconfig.conf ;\
	sed 's|/etc/nagios/okconfig/|/etc/naemon/okconfig/|g' -i /etc/okconfig.conf ;\
	sed 's|/etc/nagios/okconfig/examples|/etc/naemon/okconfig/examples|g' -i /etc/okconfig.conf


# Add naemon to apache group so it has permissions to pnp4nagios's session files
RUN usermod -G apache naemon

# Redirect root URL to /adagios
RUN echo "RedirectMatch ^/$ /adagios" > /etc/httpd/conf.d/redirect.conf

# Allow Adagios to control the service
RUN sed 's|nagios|naemon|g' -i /etc/sudoers.d/adagios ;\
	sed 's|/usr/sbin/naemon|/usr/bin/naemon|g' -i /etc/sudoers.d/adagios

# Make naemon use nagios plugins, more people are doing it like that. And configure pnp4nagios
RUN sed -i 's|/usr/lib64/naemon/plugins|/usr/lib64/nagios/plugins|g' /etc/naemon/resource.cfg ;\
	sed -i 's|/etc/nagios/passwd|/etc/thruk/htpasswd|g' /etc/httpd/conf.d/pnp4nagios.conf ;\
	sed -i 's|user = nagios|user = naemon|g' /etc/pnp4nagios/npcd.cfg ;\
	sed -i 's|group = nagios|group = naemon|g' /etc/pnp4nagios/npcd.cfg

# ACL group permissions need g+rwx
RUN	chmod g+rwx -R \
	/etc/naemon \
	/etc/adagios \
	/var/lib/adagios \
	/var/lib/pnp4nagios \
	/var/log/pnp4nagios \
	/var/spool/pnp4nagios \
	/etc/pnp4nagios/process_perfdata.cfg  \
	/var/log/okconfig

RUN setfacl -R -m group:naemon:rwx -m d:group:naemon:rwx \
	/etc/naemon/ \
	/etc/adagios \
	/var/lib/adagios \
	/var/lib/pnp4nagios \
	/var/log/pnp4nagios \
	/var/spool/pnp4nagios \
	/etc/pnp4nagios/process_perfdata.cfg \
	/var/log/okconfig


# Fix permissions for naemon and pnp4nagios
RUN chown -R naemon:naemon \
	/etc/naemon \
	/etc/adagios \
	/var/lib/adagios \
	/var/lib/pnp4nagios \
	/var/log/pnp4nagios \
	/var/spool/pnp4nagios \
	/etc/pnp4nagios/process_perfdata.cfg \
	/var/log/okconfig


# Secure Adagios
RUN mv /etc/httpd/conf.d/thruk_cookie_auth_vhost.conf /etc/httpd/conf.d/thruk_cookie_auth_vhost.conf.disabled
RUN htpasswd -b /etc/thruk/htpasswd "$ADAGIOS_USER" "$ADAGIOS_PASS" ;\
	rm -f /etc/nagios/passwd ;\
	ln -s /etc/thruk/htpasswd /etc/nagios/passwd


# Enable services
RUN chmod a-x /usr/lib/systemd/system/*.service
RUN systemctl enable httpd naemon postfix sshd daemontools haproxy rngd fail2ban redis sysstat npcd atd tinyproxy crond ncpa_listener firewalld
RUN systemctl disable ncpa_passive keepalived

# Configure Ansible Paths
RUN update-alternatives --install /usr/bin/ansible          ansible          /usr/bin/ansible-3            1; \
    update-alternatives --install /usr/bin/ansible-playbook ansible-playbook /usr/bin/ansible-playbook-3   1; \
    update-alternatives --list

COPY files/.ansi /etc/.ansi

COPY files/safeu /usr/local/bin
COPY files/fzf /usr/local/bin
RUN chmod +x /usr/local/bin/safeu /usr/local/bin/fzf
RUN chmod 644 /etc/.ansi
RUN chown root:root /usr/local/bin/safeu /usr/local/bin/fzf /etc/.ansi


# Setup Shell Environment
#RUN git clone https://github.com/nojhan/liquidprompt.git /opt/liquidprompt
COPY files/liquidprompt.tar.gz /opt
RUN cd /opt && tar zxf liquidprompt.tar.gz && unlink liquidprompt.tar.gz

RUN echo '[[ $- = *i* ]] && source /opt/liquidprompt/liquidprompt && source /etc/.ansi && source ~/.profile.sh' >> /etc/bashrc
RUN echo '[[ $- = *i* ]] && source /opt/liquidprompt/liquidprompt && source /etc/.ansi && source ~/.profile.sh' >> /etc/zshrc

COPY templates/firewalld_zones_public.xml.j2 /etc/firewalld/zones/public.xml


COPY files/ops-dashboard.tar.gz /var/www
RUN cd /var/www && tar zxf ops-dashboard.tar.gz && unlink ops-dashboard.tar.gz
