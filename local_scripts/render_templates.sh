#!/bin/bash
set -e
EXEC_PATH="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
EXEC_SCRIPT="$(basename $BASH_SOURCE)"
EXEC_ARGS="$@"
CONTAINER_NAME=${PROJECT_NAME}_${MY_CONTAINER_1_UUID}PROJECT_NAME=$MY_POD_UUID
rsync_opts="-t"
j2_args="-f yaml -e env"


cd $EXEC_PATH/..
eval $(cat setup.sh)
source .ansi
source .envrc

j2 --version  >/dev/null 2>/dev/null || pip3 install 'j2cli[yaml]' --user

get_templates(){
  find configs -name "*.j2" -type f
}

sudo chown $BUILD_USER configs nagios -R

rm -rf configs/rendered nagios/rendered_templates
mkdir configs/rendered nagios/rendered_templates

j2 $j2_args -o .firewalld_zones_public.xml templates/firewalld_zones_public.xml.j2 $LOGIC_FILE
j2 $j2_args -o .Dockerfile.base_rpms templates/Dockerfile.base_rpms.j2 $LOGIC_FILE
j2 $j2_args -o .Dockerfile.base templates/Dockerfile.base.j2 $LOGIC_FILE
j2 $j2_args -o .Dockerfile templates/Dockerfile.j2 $LOGIC_FILE
j2 $j2_args -o .Dockerfile.all templates/Dockerfile.all.j2 $LOGIC_FILE
j2 $j2_args -o .haproxy.cfg templates/haproxy.cfg.j2 $LOGIC_FILE

get_templates | while read -r template_file; do
  of="configs/rendered/$(echo -e $template_file|sed 's/\.j2$//g'|sed 's/configs\///g')"
  cmd="j2 -f yaml -o '$of' '$template_file' $LOGIC_FILE"
  eval $cmd
done

rm -rf nagios/configs nagios/templates nagios/files 
mkdir -p nagios/configs nagios/templates nagios/files nagios/configs/rendered

rsync $rsync_opts .Dockerfile.all nagios/centos_build/Dockerfile.all
rsync $rsync_opts .Dockerfile.base_rpms nagios/centos_build/Dockerfile.base_rpms
rsync $rsync_opts .Dockerfile.base nagios/centos_build/Dockerfile.base
rsync $rsync_opts .Dockerfile nagios/centos_build/Dockerfile
rsync $rsync_opts .haproxy.cfg nagios/rendered_templates/haproxy.cfg
rsync $rsync_opts .firewalld_zones_public.xml nagios/rendered_templates/firewalld_zones_public.xml

rsync $rsync_opts configs/.profile.sh nagios/files/.profile.sh
rsync $rsync_opts configs/localhost.cfg nagios/configs/localhost.cfg
rsync $rsync_opts configs/resource.cfg nagios/configs/.
rsync $rsync_opts configs/rendered/localhost2.cfg nagios/configs/rendered/.
rsync $rsync_opts configs/rendered/templates.cfg nagios/configs/rendered/.

for f in daemontools-encore-1.11-1.el7.x86_64.rpm labs-consol-stable.rhel7.noarch.rpm ok-release.rpm ncpa-2.2.2.el7.x86_64.rpm; do
    rsync $rsync_opts rpms/$f nagios/files/.
done

for f in check_haproxy neofetch check_speedtest-cli.sh check_service.pl check_systemd_service.sh log_run \
         install_borg.sh \
         naemon_plugins \
         ttyd \
         liquidprompt.tar.gz \
         bwrap_exec.sh \
         .ansi \
         fzf \
         lynis.tar.gz \
         safeu \
         bwrap_exec_with_network.sh \
         my-public-ip.tar.gz \
    ; do
    rsync $rsync_opts files/$f nagios/files/.
done

