#!/bin/bash
set -e
AUTH_USER=thrukadmin
AUTH_KEY="$(get_container_key.sh)"

curl_thruk(){
  METHOD="${2:-GET}"
  cmd="curl -X '$METHOD' -H 'X-Thruk-Auth-Key: $AUTH_KEY' \
          -H 'X-Thruk-Auth-User: thrukadmin' \
          -sk 'http://localhost:$MY_ADAGIOS_PORT/thruk/r/$1'"

  eval $cmd
}


wow(){
 curl_thruk 'hosts?columns=name:host_name,state:status'
 curl_thruk 'hosts?columns=name:host_name:hostname,state:status,address:ip'
 curl_thruk 'alerts?columns=host_name,state_type,time,plugin_output,service_description'
 curl_thruk 'checks/stats'
 curl_thruk 'commands?columns=name'
 curl_thruk 'command/check_ping'
 curl_thruk 'command/check_ping/config'
 curl_thruk 'config/diff'
 curl_thruk 'config/files'
 curl_thruk 'contactgroups'
 curl_thruk 'contacts'
 curl_thruk 'hostgroups'
 curl_thruk 'hosts/localhost/config'
 curl_thruk 'hosts/localhost/notifications'
 curl_thruk 'hosts/localhost/services'
 curl_thruk 'hosts/localhost/services?columns=description,plugin_output,perf_data,next_check,latency,display_name,host_name,last_check,last_notification,last_state_change,last_time_critical'
curl_thruk 'hosts/stats'
curl_thruk 'hosts/totals'
curl_thruk 'lmd/sites'
curl_thruk 'logs'
curl_thruk 'processinfo'
curl_thruk 'services'
curl_thruk 'services/stats'
curl_thruk 'services/totals'
curl_thruk 'sites'
curl_thruk 'thruk'
curl_thruk 'thruk/api_keys'
curl_thruk 'thruk/cluster'
curl_thruk 'thruk/config'
curl_thruk 'thruk/jobs'
curl_thruk 'thruk/users'
curl_thruk 'thruk/whoami'
   curl_thruk 'config/files?columns=path,content,mtimme,hex'
}
curl_thruk 'config/check' POST
#curl_thruk 'services/localhost/'
#curl_thruk 'config/objects'
#curl_thruk 'config/fullobjects'

#wow
curl_thruk 'processinfo/stats'

