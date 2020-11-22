#!/bin/bash
set -e
eval $(cat setup.sh)
eval $(cat .envrc)
get_templates(){
  find configs -name "*.j2"
}

rm -rf configs/rendered
mkdir configs/rendered

j2_args="-f yaml -eenv"

j2 $j2_args -o .Dockerfile Dockerfile.j2 $LOGIC_FILE
j2 $j2_args -o .Dockerfile.base Dockerfile.base.j2 $LOGIC_FILE
j2 $j2_args -o .haproxy.cfg haproxy.cfg.j2 $LOGIC_FILE

get_templates | while read -r template_file; do
  of="configs/rendered/$(echo -e $template_file|sed 's/\.j2$//g'|sed 's/configs\///g')"
  cmd="j2 -f yaml -o '$of' '$template_file' $LOGIC_FILE"
  echo $cmd
  eval $cmd
done
