FROM nagios-67b7cb03:latest as phase_1

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

RUN rm -f /etc/naemon/conf.d/windows.cfg \
    /etc/nagios/objects/windows.cfg \
    /etc/nagios/objects/printer.cfg \
    /etc/naemon/conf.d/switch.cfg \
    /etc/nagios/objects/switch.cfg \
    /etc/naemon/conf.d/printer.cfg  \
    /etc/naemon/conf.d/localhost.cfg \
    /etc/naemon/conf.d/templates/services.cfg

RUN mkdir -p /etc/naemon/commands \
             /etc/naemon/services \
             /usr/share/okconfig/templates/whmcs \
             /etc/nagios/okconfig/examples \
             /etc/nagios/okconfig/services/whmcs \
             /etc/nagios/okconfig/commands/whmcs \
             /etc/naemon/conf.d

COPY configs/localhost.cfg /etc/naemon/conf.d

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




COPY files/check_systemd_service.sh /usr/lib64/nagios/plugins
RUN  chmod +x /usr/lib64/nagios/plugins/check_systemd_service.sh

COPY files/check_haproxy /usr/lib64/nagios/plugins
RUN  chmod +x /usr/lib64/nagios/plugins/check_haproxy




#   CREDENTIALS
RUN rm -f /etc/thruk/htpasswd; htpasswd -cb /etc/thruk/htpasswd "$ADAGIOS_USER" "$ADAGIOS_PASS" ;\
    rm -f /etc/nagios/passwd ;\
    ln -s /etc/thruk/htpasswd /etc/nagios/passwd



RUN naemon-ctl configtest
RUN neofetch > /etc/motd
RUN updatedb

WORKDIR /etc/naemon

EXPOSE 80

VOLUME ["/etc/naemon", "/var/log/naemon"]
CMD ["/usr/sbin/init"]

HEALTHCHECK --interval=2m --timeout=3s CMD curl -f http://localhost:80/ || exit 1



