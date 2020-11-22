#!/bin/bash
set -e
dur=10
podman_cmd="echo -e; echo -e Containers; sudo podman ps; echo -e Pods; sudo podman pod ps"
xpanes_args="-s -l ev"

tmux_cmd=""
for index in $(seq 1 $MAX_DEV_DOMAIN_INDEX); do
  tf=$(mktemp)
  chmod +x $tf
  varname="DEV_DOMAIN_$index"
  DEV_DOMAIN="${!varname}"
  varname="DEV_DOMAIN_${index}_IP"
  DEV_IP="${!varname}"
  DEV_URL_1="http://$DEV_DOMAIN_USERNAME:$DEV_DOMAIN_PASSWORD@localhost:${index}${DEV_PORT_1}/adagios/status"
  ssh_args="-tt -oStrictHostKeyChecking=no -oLogLevel=ERROR -oControlMaster=no -L ${index}$DEV_PORT_2:127.0.0.1:$DEV_PORT_2 -L ${index}$DEV_PORT_1:127.0.0.1:$MY_ADAGIOS_PORT"
  remote_cmd="bash -c \"while [[ 1 ]]; do clear; hostname -f; $podman_cmd; echo -e \\\"\\\n\\\n$DEV_URL_1\\\n\\\n\\\";netstat -alntp|egrep \\\":$MY_ADAGIOS_PORT|:$DEV_PORT_2\\\"; sleep $dur; done\""
  cmd="command ssh -oHostName='$DEV_IP' $ssh_args '$DEV_DOMAIN' '$remote_cmd'"

  echo -e "$cmd" > $tf
  tmux_cmd="$tmux_cmd 'echo $(cat $tf|base64 -w0) | base64 -d | bash'"
  unlink $tf
done

tmux_cmd="command env DEV_PORT_FWDS=1 command bash -c \"command xpanes $xpanes_args -e $tmux_cmd\""
echo $tmux_cmd
