eval $(cat setup.sh)
data_file=data.yaml
get_templates(){
  find configs -name "*.j2"
}

rm -rf configs/rendered
mkdir configs/rendered

j2 -f yaml -o .Dockerfile Dockerfile.j2 $data_file
j2 -f yaml -o .Dockerfile.base Dockerfile.base.j2 $data_file

get_templates | while read -r template_file; do
  of="configs/rendered/$(echo -e $template_file|sed 's/\.j2$//g'|sed 's/configs\///g')"
  cmd="j2 -f yaml -o '$of' '$template_file' $data_file"
  echo $cmd
  eval $cmd
done
