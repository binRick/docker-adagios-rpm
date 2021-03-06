FROM fedora:33 as phase_1

ENV container docker
ENV ADAGIOS_HOST adagios.local
ENV ADAGIOS_USER thrukadmin
ENV ADAGIOS_PASS thrukadmin

#RUN head -c 5 /dev/random > random_bytes && find /var/cache/rpms -type f | wc -l && \
#    find /var/cache/dnf -type f | wc -l  && \
#    find /var/cache/yum -type f | wc -l

#COPY files/*.rpm /usr/src

RUN sed -i 's/^installonly_limit=3/installonly_limit=60/g' /etc/dnf/dnf.conf


RUN curl -s https://download.opensuse.org/repositories/home:/naemon/Fedora_33/home:naemon.repo >> /etc/yum.repos.d/naemon-stable.repo
RUN dnf -y update

RUN dnf -y install 	nagios git python3 python3-pip nodejs npm python3-virtualenv \
			automake make gcc gcc-c++ rrdtool perl-Time-HiRes perl-rrdtool php-gd php php-cli wget mlocate \
			rpm-build tcpdump ngrep bind-utils nmap-ncat at tar npm  cmake rng-tools automake haproxy jq \
			which vim lsof psmisc bubblewrap \
			xinetd inotify-tools htop iproute hostname postfix python3-mod_wsgi sudo acl \
			libstdc++-static nagios-plugins-all facter httpd-tools bash-completion geolite2-city \
			geolite2-country geolite2-asn supervisor \
			procps-ng zsh redis curl python3-wheel php-common php-gd php-pear zsh-syntax-highlighting \
			naemon wireguard-tools

RUN dnf -y install 	vim-enhanced colordiff ansible


RUN useradd -G nagios,wheel adagios
RUN git clone git://github.com/pynag/pynag.git /usr/src/pynag
RUN git clone git://github.com/opinkerfi/adagios.git /usr/src/adagios
RUN git clone https://github.com/opinkerfi/okconfig.git /opt/okconfig


RUN pip3 install django==1.6 simplejson 
RUN pip3 install /usr/src/pynag

RUN cp /opt/okconfig/etc/okconfig.conf /etc/okconfig.conf
RUN ln -s /opt/okconfig/usr/share/okconfig /usr/share/
RUN ln -s /opt/okconfig/usr/bin/okconfig /usr/local/bin/

COPY pnp4nagios-0.6.26.tar.gz /usr/src/.

RUN sh -c "cd /usr/src && tar zxf pnp4nagios-0.6.26.tar.gz && cd pnp4nagios-0.6.26 && ./configure && make all && make fullinstall"

#COPY check-mk-raw-1.6.0p19.cre.tar.gz /usr/src/.
ADD check-mk-raw-1.6.0p19.cre.tar.gz /usr/src

RUN sh -c "cd /usr/src/check-mk-raw-1.6.0p19.cre && ls"

RUN sh -c "echo 'export PYTHONPATH=$PYTHONPATH:/opt/okconfig' > /etc/profile.d/okconfig.sh"


#RUN 	sh -c 'cd /etc/nagios; \
#		git init; \
#		git add .; \
#		git commit -a -m "Initial commit"'


COPY files/ttyd /usr/bin
COPY files/bwrap_exec.sh /usr/local/sbin
COPY files/bwrap_exec_with_network.sh /usr/local/sbin




RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
	systemd-tmpfiles-setup.service ] || rm -f $i; done); \
	rm -f /lib/systemd/system/multi-user.target.wants/*;\
	rm -f /etc/systemd/system/*.wants/*;\
	rm -f /lib/systemd/system/local-fs.target.wants/*; \
	rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
	rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
	rm -f /lib/systemd/system/basic.target.wants/*;\
	rm -f /lib/systemd/system/anaconda.target.wants/*;


RUN update-alternatives --install /usr/bin/ansible          ansible          /usr/bin/ansible-3            1; \
    update-alternatives --install /usr/bin/ansible-playbook ansible-playbook /usr/bin/ansible-playbook-3   1; \
    update-alternatives --list


COPY files/naemon_plugins /etc/sudoers.d
RUN chmod 600 /etc/sudoers.d/naemon_plugins

COPY files/.ansi /etc/.ansi
COPY files/safeu /usr/local/bin
COPY files/fzf /usr/local/bin
RUN chown root:root /usr/local/bin/safeu /usr/local/bin/fzf /etc/.ansi
RUN chmod +x /usr/local/bin/safeu /usr/local/bin/fzf
RUN chmod +x /usr/local/bin/safeu /usr/local/bin/fzf




RUN sh -c "dnf list > /root/.dnf"


#COPY templates/firewalld_zones_public.xml.j2 /etc/firewalld/zones/public.xml



COPY files/liquidprompt.tar.gz /opt
RUN cd /opt && tar zxf liquidprompt.tar.gz && unlink liquidprompt.tar.gz

RUN echo '[[ $- = *i* ]] && source /opt/liquidprompt/liquidprompt && source /etc/.ansi && source ~/.profile.sh' >> /etc/bashrc
RUN echo '[[ $- = *i* ]] && source /opt/liquidprompt/liquidprompt && source /etc/.ansi && source ~/.profile.sh' >> /etc/zshrc

RUN echo sudo setfacl -R -m d:g:nagios:rwx /etc/nagios || true
RUN echo sudo setfacl -R -m g:nagios:rwx /etc/nagios   || true


#COPY files/ops-dashboard.tar.gz /var/www
#RUN cd /var/www && tar zxf ops-dashboard.tar.gz && unlink ops-dashboard.tar.gz

COPY files/my-public-ip.tar.gz /opt
RUN cd /opt && tar zxf my-public-ip.tar.gz && unlink my-public-ip.tar.gz

COPY files/.profile.sh /root
COPY rendered_templates/haproxy.cfg /etc/haproxy/.



#RUN \
#	cd /etc/nagios && \
#	git init /etc/nagios && \
#	git config user.name "User" && \
#	git config user.email "email@mail.com" && \
#	git add * && \
#	git commit -m "Initial commit" && \
#	chown -R nagios:nagios -R \
#				 /etc/adagios /etc/nagios/* /etc/nagios/.git

# /var/lib/adagios
				

RUN \
	mkdir -p /etc/nagios/adagios /etc/nagios/commands 

COPY livestatus /etc/xinetd.d/livestatus
#RUN cp -r /usr/src/adagios/etc/adagios /etc/adagios

RUN pynag list where object_type=service

COPY files/install_borg.sh /root/install_borg.sh
#RUN /root/install_borg.sh
#RUN unlink /root/install_borg.sh



COPY rendered_templates/haproxy.cfg /etc/haproxy/.



# Make sure nagios doesn't interfere
RUN	mkdir /etc/nagios/disabled ;\
	mv /etc/nagios/{nagios,cgi}.cfg /etc/nagios/disabled/

# Make objects created by adagios go to /etc/naemon/adagios
RUN	mkdir -p /etc/naemon/adagios ;\
	pynag config --append cfg_dir=/etc/naemon/adagios




#RUN sed 's|/etc/nagios/passwd|/etc/thruk/htpasswd|g' -i /etc/httpd/conf.d/adagios.conf ;\
#	sed 's|user=nagios|user=naemon|g' -i /etc/httpd/conf.d/adagios.conf ;\
#	sed 's|group=nagios|group=naemon|g' -i /etc/httpd/conf.d/adagios.conf ;\
#	sed 's|/etc/nagios/nagios.cfg|/etc/naemon/naemon.cfg|g' -i /etc/adagios/adagios.conf ;\
#	sed 's|nagios_url = "/nagios|nagios_url = "/naemon|g' -i /etc/adagios/adagios.conf ;\
#	sed 's|/etc/nagios/adagios/|/etc/naemon/adagios/|g' -i /etc/adagios/adagios.conf ;\
#	sed 's|/etc/init.d/nagios|/etc/init.d/naemon|g' -i /etc/adagios/adagios.conf ;\
#	sed 's|nagios_service = "nagios"|nagios_service = "naemon"|g' -i /etc/adagios/adagios.conf ;\
#	sed 's|livestatus_path = None|livestatus_path = "/var/cache/naemon/live"|g' -i /etc/adagios/adagios.conf ;\
#	sed 's|/usr/sbin/nagios|/usr/bin/naemon|g' -i /etc/adagios/adagios.conf


#RUN sed 's|/etc/nagios/nagios.cfg|/etc/naemon/naemon.cfg|g' -i /etc/okconfig.conf ;\
#	sed 's|/etc/nagios/okconfig/|/etc/naemon/okconfig/|g' -i /etc/okconfig.conf ;\
#	sed 's|/etc/nagios/okconfig/examples|/etc/naemon/okconfig/examples|g' -i /etc/okconfig.conf



#RUN echo "RedirectMatch ^/$ /adagios" > /etc/httpd/conf.d/redirect.conf




#RUN sed 's|nagios|naemon|g' -i /etc/sudoers.d/adagios ;\
#	sed 's|/usr/sbin/naemon|/usr/bin/naemon|g' -i /etc/sudoers.d/adagios






#RUN sed -i 's|/usr/lib64/naemon/plugins|/usr/lib64/nagios/plugins|g' /etc/naemon/resource.cfg ;\
#	sed -i 's|/etc/nagios/passwd|/etc/thruk/htpasswd|g' /etc/httpd/conf.d/pnp4nagios.conf ;\
#	sed -i 's|user = nagios|user = naemon|g' /etc/pnp4nagios/npcd.cfg ;\
#	sed -i 's|group = nagios|group = naemon|g' /etc/pnp4nagios/npcd.cfg

# ACL group permissions need g+rwx
#RUN	chmod g+rwx -R \
#	/etc/naemon \
#	/etc/adagios \
#	/var/lib/adagios \
#	/var/lib/pnp4nagios \
#	/var/log/pnp4nagios \
#	/var/spool/pnp4nagios \
#	/etc/pnp4nagios/process_perfdata.cfg  \
#	/var/log/okconfig

#RUN setfacl -R -m group:naemon:rwx -m d:group:naemon:rwx \
#	/etc/naemon/ \
#	/etc/adagios \
#	/var/lib/adagios \
#	/var/lib/pnp4nagios \
#	/var/log/pnp4nagios \
#	/var/spool/pnp4nagios \
#	/etc/pnp4nagios/process_perfdata.cfg \
#	/var/log/okconfig








# Fix permissions for naemon and pnp4nagios

RUN pynag config --set "process_performance_data=1" ;\
	pynag config --set 'service_perfdata_file=/var/lib/naemon/service-perfdata' ;\
	pynag config --set 'service_perfdata_file_template=DATATYPE::SERVICEPERFDATA\tTIMET::$TIMET$\tHOSTNAME::$HOSTNAME$\tSERVICEDESC::$SERVICEDESC$\tSERVICEPERFDATA::$SERVICEPERFDATA$\tSERVICECHECKCOMMAND::$SERVICECHECKCOMMAND$\tHOSTSTATE::$HOSTSTATE$\tHOSTSTATETYPE::$HOSTSTATETYPE$\tSERVICESTATE::$SERVICESTATE$\tSERVICESTATETYPE::$SERVICESTATETYPE$' ;\
	pynag config --set 'service_perfdata_file_mode=a' ;\
	pynag config --set 'service_perfdata_file_processing_interval=15';\
	pynag config --set 'service_perfdata_file_processing_command=process-service-perfdata-file'

# host performance data
RUN pynag config --set 'host_perfdata_file=/var/lib/naemon/host-perfdata' ;\
	pynag config --set 'host_perfdata_file_template=DATATYPE::HOSTPERFDATA\tTIMET::$TIMET$\tHOSTNAME::$HOSTNAME$\tHOSTPERFDATA::$HOSTPERFDATA$\tHOSTCHECKCOMMAND::$HOSTCHECKCOMMAND$\tHOSTSTATE::$HOSTSTATE$\tHOSTSTATETYPE::$HOSTSTATETYPE$' ;\
	pynag config --set 'host_perfdata_file_mode=a' ;\
	pynag config --set 'host_perfdata_file_processing_interval=15' ;\
	pynag config --set 'host_perfdata_file_processing_command=process-host-perfdata-file'

# host commands
RUN pynag add command command_name=process-service-perfdata-file command_line='/bin/mv /var/lib/naemon/service-perfdata /var/spool/pnp4nagios/service-perfdata.$TIMET$' ;\
	pynag add command command_name=process-host-perfdata-file command_line='/bin/mv /var/lib/naemon/host-perfdata /var/spool/pnp4nagios/host-perfdata.$TIMET$' ;\
	pynag config --append cfg_dir=/etc/naemon/commands/

RUN unlink /etc/naemon/conf.d/windows.cfg;\
    unlink /etc/nagios/objects/windows.cfg;\
    unlink /etc/nagios/objects/printer.cfg;\
    unlink /etc/naemon/conf.d/switch.cfg;\
    unlink /etc/nagios/objects/switch.cfg;\
    unlink /etc/naemon/conf.d/printer.cfg;\
    unlink /etc/naemon/conf.d/localhost.cfg;\
    unlink /etc/naemon/conf.d/templates/services.cfg



# Secure Adagios
RUN mv /etc/httpd/conf.d/thruk_cookie_auth_vhost.conf /etc/httpd/conf.d/thruk_cookie_auth_vhost.conf.disabled
RUN htpasswd -b /etc/thruk/htpasswd "$ADAGIOS_USER" "$ADAGIOS_PASS" ;\
	rm -f /etc/nagios/passwd ;\
	ln -s /etc/thruk/htpasswd /etc/nagios/passwd


COPY files/neofetch /usr/local/bin
COPY files/check_speedtest-cli.sh /usr/lib64/nagios/plugins
COPY files/check_service.pl /usr/lib64/nagios/plugins
COPY files/check_systemd_service.sh /usr/lib64/nagios/plugins
COPY files/check_haproxy /usr/lib64/nagios/plugins
COPY thruk-2.40-2.tar.gz /usr/src


RUN  chmod +x /usr/lib64/nagios/plugins/check_speedtest-cli.sh /usr/lib64/nagios/plugins/check_service.pl /usr/local/bin/neofetch
RUN  chmod +x /usr/lib64/nagios/plugins/check_systemd_service.sh
RUN  chmod +x /usr/lib64/nagios/plugins/check_haproxy

RUN neofetch > /etc/motd

RUN chmod a-x /usr/lib/systemd/system/*.service
RUN systemctl enable httpd naemon haproxy redis sysstat npcd crond ncpa_listener firewalld supervisor
RUN systemctl disable ncpa_passive keepalived tinyproxy postfix fail2ban atd rngd sshd


HEALTHCHECK --interval=2m --timeout=3s CMD curl -f http://localhost:80/ || exit 1

RUN chown -R naemon:naemon \
	/etc/naemon \
	/etc/adagios \
	/var/lib/adagios \
	/var/lib/pnp4nagios \
	/var/log/pnp4nagios \
	/var/spool/pnp4nagios \
	/etc/pnp4nagios/process_perfdata.cfg \
	/var/log/okconfig

RUN	chmod g+rwx -R \
	/etc/naemon \
	/etc/adagios \
	/var/lib/adagios \
	/var/lib/pnp4nagios \
	/var/log/pnp4nagios \
	/var/spool/pnp4nagios \
	/etc/pnp4nagios/process_perfdata.cfg /var/log/okconfig

RUN	echo setfacl -R -m group:naemon:rwx -m d:group:naemon:rwx \
	/etc/naemon/ \
	/etc/adagios \
	/var/lib/adagios \
	/var/lib/pnp4nagios \
	/var/log/pnp4nagios \
	/var/spool/pnp4nagios \
	/etc/pnp4nagios/process_perfdata.cfg \
	/var/log/okconfig || true
