#!/bin/bash
data_file=data.yaml
get_templates(){
  find configs -name "*.j2"
}

rm -rf configs/rendered
mkdir configs/rendered

get_templates | while read -r template_file; do
  of="configs/rendered/$(echo -e $template_file|sed 's/\.j2$//g'|sed 's/configs\///g')"
  cmd="j2 -f yaml -o '$of' '$template_file' $data_file"
  echo $cmd
  eval $cmd
done
