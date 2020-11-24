#!/bin/bash
set -e
dur=10
podman_cmd="echo -e; echo -e Containers; sudo podman ps; echo -e Pods; sudo podman pod ps"
xpanes_args="-s -l ev"

pod_stats_cmd="sudo podman pod stats --no-reset --no-stream -a"

tmux_cmd=""
for index in $(seq 1 $MAX_DEV_DOMAIN_INDEX); do
  tf=$(mktemp)
  chmod +x $tf
  varname="DEV_DOMAIN_$index"
  DEV_DOMAIN="${!varname}"
  varname="DEV_DOMAIN_${index}_IP"
  DEV_IP="${!varname}"
  varname="DEV_DOMAIN_${index}_ADAGIOS_PORT"
  ADG_PORT="${!varname}"
  varname="DEV_DOMAIN_${index}_HAPROXY_PORT"
  TTYD_PORT="${!varname}"
  DEV_URL_1="http://$DEV_DOMAIN_USERNAME:$DEV_DOMAIN_PASSWORD@localhost:${index}${DEV_PORT_1}/adagios/status"
  line_break="echo -e \\\"\\\n\\\""
  netstat_cmd="netstat -alntp|egrep \\\":$MY_ADAGIOS_PORT|:$DEV_PORT_2\\\"|head -n5"
  ssh_args="-tt -oStrictHostKeyChecking=no -oLogLevel=ERROR -oControlMaster=no -L ${index}$DEV_PORT_2:127.0.0.1:$TTYD_PORT -L ${index}$DEV_PORT_1:127.0.0.1:$ADG_PORT"
  remote_cmd="bash -c \"while [[ 1 ]]; do clear; hostname -f; $podman_cmd; echo -e \\\"\\\n\\\n$DEV_URL_1\\\n\\\n\\\"; echo -e \\\"\\\n\\\"; $pod_stats_cmd; $netstat_cmd; $line_break; sleep $dur; done\""
  cmd="command ssh -oHostName='$DEV_IP' $ssh_args '$DEV_DOMAIN' '$remote_cmd'"

  echo -e "$cmd" > $tf

  >&2 echo -e "\n$cmd\n"

  tmux_cmd="$tmux_cmd 'echo $(cat $tf|base64 -w0) | base64 -d | bash'"
  unlink $tf
done

tmux_cmd="command env DEV_PORT_FWDS=1 command bash -c \"command xpanes $xpanes_args -e $tmux_cmd\""
echo $tmux_cmd
