FROM a44f8bfa-877f-45ae-9a9b-116346a03161:latest

ENV container docker
ENV ADAGIOS_HOST adagios.local
ENV ADAGIOS_USER thrukadmin
ENV ADAGIOS_PASS thrukadmin

# Enable Naemon performance data and service performance data
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
    unlink /etc/naemon/conf.d/switch.cfg ;\
    unlink /etc/nagios/objects/switch.cfg;\
    unlink /etc/naemon/conf.d/printer.cfg ;\
    unlink /etc/naemon/conf.d/localhost.cfg


COPY configs/localhost.cfg /etc/naemon/conf.d

RUN mkdir -p /etc/naemon/commands \
             /etc/naemon/services \
             /usr/share/okconfig/templates/whmcs \
             /etc/nagios/okconfig/examples \
             /etc/nagios/okconfig/services/whmcs \
             /etc/nagios/okconfig/commands/whmcs

RUN touch /var/log/naemon/livestatus.log && chown naemon:naemon /var/log/naemon/livestatus.log
RUN touch /var/log/naemon/debug.log && chown naemon:naemon /var/log/naemon/debug.log


COPY files/neofetch /usr/local/bin
COPY files/check_speedtest-cli.sh /usr/lib64/nagios/plugins
COPY files/check_service.pl /usr/lib64/nagios/plugins
RUN chmod +x /usr/lib64/nagios/plugins/check_speedtest-cli.sh /usr/lib64/nagios/plugins/check_service.pl /usr/local/bin/neofetch

COPY configs/resource.cfg       /etc/naemon
#COPY configs/whmcs/commands.cfg  /etc/nagios/okconfig/commands/whmcs
#COPY configs/whmcs/services.cfg  /etc/nagios/okconfig/services/whmcs
COPY configs/rendered/*.cfg      /etc/naemon/conf.d

#RUN pynag config --append cfg_dir=/etc/nagios/okconfig/services/whmcs
#RUN pynag config --append cfg_dir=/etc/nagios/okconfig/commands/whmcs

#RUN unlink /etc/naemon/objects/templates.cfg
#RUN unlink /etc/naemon/conf.d/templates.cfg
#RUN unlink /etc/naemon/resource.cfg
RUN unlink /etc/naemon/conf.d/templates/services.cfg



COPY files/check_systemd_service.sh /usr/lib64/nagios/plugins
RUN  chmod +x /usr/lib64/nagios/plugins/check_systemd_service.sh

COPY files/check_haproxy /usr/lib64/nagios/plugins
RUN  chmod +x /usr/lib64/nagios/plugins/check_haproxy




RUN mkdir -p /service/ttyd1/log

RUN echo -e '#!/bin/bash\nset -e\nsleep 0; exec ttyd -p 6001 -i lo zsh 2>&1\n' > /service/ttyd1/run
COPY bin/run /service/ttyd1/log
RUN chmod +x /service/ttyd1/run /service/ttyd1/log/run

RUN mkdir -p /service/ttyd1_socat/log

RUN echo -e '#!/bin/bash\nset -e\nexec mkdir -p /var/run/ttyd1 2>&1\n' > /service/ttyd1_socat/start && chmod +x /service/ttyd1_socat/start

RUN echo -e '#!/bin/bash\nset -e\necho PRE_EXEC; exec socat TCP-LISTEN:41992,reuseaddr,fork UNIX-CONNECT:/var/run/ttyd1/ttyd.sock 2>&1\n' > /service/ttyd1_socat/run
COPY bin/run /service/ttyd1_socat/log
RUN chmod +x /service/ttyd1_socat/run /service/ttyd1_socat/log/run

RUN mkdir -p /service/ttyd1_socket/log

RUN echo -e '#!/bin/bash\nset -e\nexec mkdir -p /var/run/ttyd1 2>&1\n' > /service/ttyd1_socket/start && chmod +x /service/ttyd1_socket/start

RUN echo -e '#!/bin/bash\nset -e\nsleep 0; exec bwrap_exec.sh --unshare-uts --bind /var/run/ttyd1 /var/run/ttyd1 ttyd -p 0 -i /var/run/ttyd1/ttyd.sock zsh 2>&1\n' > /service/ttyd1_socket/run
COPY bin/run /service/ttyd1_socket/log
RUN chmod +x /service/ttyd1_socket/run /service/ttyd1_socket/log/run

RUN mkdir -p /service/ttyd1_socat_bwrap_networked/log

RUN echo -e '#!/bin/bash\nset -e\nexec mkdir -p /var/run/ttyd1_socket_bwrap_networked 2>&1\n' > /service/ttyd1_socat_bwrap_networked/start && chmod +x /service/ttyd1_socat_bwrap_networked/start

RUN echo -e '#!/bin/bash\nset -e\necho PRE_EXEC; exec socat TCP-LISTEN:41993,reuseaddr,fork UNIX-CONNECT:/var/run/ttyd1_socket_bwrap_networked/ttyd.sock 2>&1\n' > /service/ttyd1_socat_bwrap_networked/run
COPY bin/run /service/ttyd1_socat_bwrap_networked/log
RUN chmod +x /service/ttyd1_socat_bwrap_networked/run /service/ttyd1_socat_bwrap_networked/log/run

RUN mkdir -p /service/ttyd1_socket_bwrap_networked/log

RUN echo -e '#!/bin/bash\nset -e\nexec mkdir -p /var/run/ttyd1_socket_bwrap_networked 2>&1\n' > /service/ttyd1_socket_bwrap_networked/start && chmod +x /service/ttyd1_socket_bwrap_networked/start

RUN echo -e '#!/bin/bash\nset -e\nsleep 0; exec bwrap_exec_with_network.sh --bind /var/run/ttyd1_socket_bwrap_networked /var/run/ttyd1_socket_bwrap_networked ttyd -p 0 -i /var/run/ttyd1_socket_bwrap_networked/ttyd.sock zsh 2>&1\n' > /service/ttyd1_socket_bwrap_networked/run
COPY bin/run /service/ttyd1_socket_bwrap_networked/log
RUN chmod +x /service/ttyd1_socket_bwrap_networked/run /service/ttyd1_socket_bwrap_networked/log/run


RUN echo '[[ $- = *i* ]] && svstat /service/*' > /etc/profile.d/daemontools.sh && chmod 755 /etc/profile.d/daemontools.sh


RUN naemon-ctl configtest

RUN updatedb

WORKDIR /etc/naemon

EXPOSE 80

VOLUME ["/etc/naemon", "/var/log/naemon"]
CMD ["/usr/sbin/init"]

HEALTHCHECK --interval=2m --timeout=3s CMD curl -f http://localhost:80/ || exit 1

RUN neofetch > /etc/motd


