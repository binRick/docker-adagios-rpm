#!/bin/bash
set -e
eval $(cat setup.sh)
source .ansi
source .envrc

get_templates(){
  find configs -name "*.j2"
}

rm -rf configs/rendered
mkdir configs/rendered

j2_args="-f yaml -eenv"

j2 $j2_args -o .Dockerfile.base_rpms templates/Dockerfile.base_rpms.j2 $LOGIC_FILE
j2 $j2_args -o .Dockerfile.base templates/Dockerfile.base.j2 $LOGIC_FILE
j2 $j2_args -o .Dockerfile templates/Dockerfile.j2 $LOGIC_FILE
j2 $j2_args -o .Dockerfile.all templates/Dockerfile.all.j2 $LOGIC_FILE
j2 $j2_args -o .haproxy.cfg templates/haproxy.cfg.j2 $LOGIC_FILE

cp -prvf .Dockerfile.all nagios/centos_build/Dockerfile.all

get_templates | while read -r template_file; do
  of="configs/rendered/$(echo -e $template_file|sed 's/\.j2$//g'|sed 's/configs\///g')"
  cmd="j2 -f yaml -o '$of' '$template_file' $LOGIC_FILE"
  eval $cmd
done
