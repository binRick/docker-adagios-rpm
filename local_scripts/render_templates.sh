#!/bin/bash
set -e
eval $(cat setup.sh)
source .ansi
source .envrc
rsync_opts="-vrt"
j2_args="-f yaml -eenv"
j2 --version  >/dev/null 2>/dev/null || pip3 install 'j2cli[yaml]' --user

get_templates(){
  find configs -name "*.j2" -type f
}

sudo chown vpntech configs nagios -R

rm -rf configs/rendered
mkdir configs/rendered

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

rm -rf nagios/configs nagios/templates



rsync $rsync_opts .Dockerfile.all nagios/centos_build/Dockerfile.all
rsync $rsync_opts .Dockerfile.base_rpms nagios/centos_build/Dockerfile.base_rpms
rsync $rsync_opts .Dockerfile.base nagios/centos_build/Dockerfile.base
rsync $rsync_opts .Dockerfile nagios/centos_build/Dockerfile
diff .haproxy.cfg nagios/.haproxy.cfg && rsync $rsync_opts .haproxy.cfg nagios/
rsync $rsync_opts configs nagios/.
rsync $rsync_opts templates nagios/.
