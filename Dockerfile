#FROM centos:7
FROM adagios_systemd_image_base:latest

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

#RUN pynag list host_name WHERE object_type=host --quiet|grep -v '^null'|sort -u
RUN unlink /etc/naemon/conf.d/windows.cfg ;\
    unlink /etc/naemon/conf.d/switch.cfg ;\
    unlink /etc/naemon/conf.d/printer.cfg ;\
    unlink /etc/naemon/conf.d/localhost.cfg

COPY configs/localhost.cfg /etc/naemon/conf.d

#RUN pynag list host_name WHERE object_type=host --quiet|grep -v '^null'|sort -u

RUN mkdir -p /etc/naemon/commands \
             /etc/naemon/services \
             /usr/share/okconfig/templates/whmcs \
             /etc/nagios/okconfig/examples \
             /etc/nagios/okconfig/services/whmcs \
             /etc/nagios/okconfig/commands/whmcs


#COPY configs/whmcs.cfg-example /etc/nagios/okconfig/examples
#COPY configs/whmcs-services.cfg /etc/nagios/okconfig/services
#COPY configs/whmcs-commands.cfg /etc/nagios/okconfig/commands

COPY configs/whmcs/commands.cfg  /etc/nagios/okconfig/commands/whmcs
COPY configs/whmcs/services.cfg  /etc/nagios/okconfig/services/whmcs


#RUN sh -c 'id'

#COPY configs/commands/*.cfg /etc/naemon/commands/
#RUN pynag config --append cfg_dir=/etc/naemon/commands
RUN pynag config --append cfg_dir=/etc/nagios/okconfig/services/whmcs
RUN pynag config --append cfg_dir=/etc/nagios/okconfig/commands/whmcs


#COPY configs/services/*.cfg /etc/naemon/services/
#RUN pynag config --append cfg_dir=/etc/naemon/services

#RUN okconfig addhost --host linuxhost.example.com --address 127.1.1.1 --template linux
#RUN okconfig addtemplate linuxhost.example.com --template=http

RUN okconfig addgroup whmcs_interfaces --alias "WHMCS Interfaces"
RUN okconfig addgroup whmcs_database_interfaces --alias "WHMCS Database Interfaces"
RUN okconfig addgroup whmcs_api_interfaces --alias "WHMCS API Interfaces"
RUN okconfig addgroup whmcs_servers --alias "WHMCS Servers"

RUN okconfig addhost --host web1.vpnservice.company --address 50.116.46.88 \
    --group whmcs_interfaces
RUN okconfig addservice host_name=web1.vpnservice.company \
                        use=okc-whmcs-http-api-tcp
RUN okconfig addservice host_name=web1.vpnservice.company \
                        use=okc-whmcs-http-api-tls
RUN okconfig addservice host_name=web1.vpnservice.company \
                        use=okc-whmcs-http-api-http
RUN okconfig addservice host_name=web1.vpnservice.company \
                        use=okc-whmcs-http-api-auth
RUN okconfig addservice host_name=web1.vpnservice.company \
                        use=okc-whmcs-http-api-cert

#RUN okconfig addhost --host db1.vpnservice.company --address 127.1.50.3 \
#    --group whmcs_database_interfaces
#RUN okconfig addservice host_name=db1.vpnservice.company \
#                        use=okc-whmcs-database-tcp
#RUN okconfig addservice host_name=db1.vpnservice.company \
#                        use=okc-whmcs-database-mysql
#RUN okconfig addservice host_name=db1.vpnservice.company \
#                        use=okc-whmcs-database-auth

#RUN okconfig addhost --host api1.vpnservice.company --address 127.1.50.3 \
#    --group whmcs_interfaces
#RUN okconfig addservice host_name=api1.vpnservice.company \
#                        use=okc-whmcs-http-api-tcp
#RUN okconfig addservice host_name=api1.vpnservice.company \
#                        use=okc-whmcs-http-api-tls
#RUN okconfig addservice host_name=api1.vpnservice.company \
#                        use=okc-whmcs-http-api-http
#RUN okconfig addservice host_name=api1.vpnservice.company \
#                        use=okc-whmcs-http-api-auth

#RUN okconfig addhost --host host1.example.com --address 127.1.1.2 --group whmcs_servers
#RUN okconfig addservice host_name=host1.example.com use=okc-whmcs-ping
#RUN okconfig addservice host_name=host1.example.com use=okc-whmcs-ping2
#RUN okconfig addservice host_name=host1.example.com use=okc-whmcs-ping2 service_description="my pinger"

#RUN okconfig addhost --host whmcs.example.com --address 127.1.1.3 --template=http


#RUN for x in $(seq 1 10); do \
#  okconfig addhost --host whmcs${x}.example.com --address 127.1.10.${x} --group whmcs_servers; \
#done
#  HN="whmcs${x}.example.com"; \
#  okconfig addservice host_name=$HN use=whmcs; \

#RUN okconfig addservice host_name=linuxhost.example.com use=check_ncpa_agent_tcp_port 
#RUN okconfig addtemplate --host example.com --template https


#RUN naemon-ctl configtest || sleep 60;\
#    okconfig listhosts;\
#    okconfig listtemplates;\
#    okconfig verify







RUN naemon-ctl configtest || sleep 600

#RUN naemonstats|grep 'Total Services' -A 4
WORKDIR /etc/naemon

EXPOSE 80

VOLUME ["/etc/naemon", "/var/log/naemon"]
CMD ["/usr/sbin/init"]

HEALTHCHECK --interval=2m --timeout=3s CMD curl -f http://localhost:80/ || exit 1
