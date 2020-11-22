
curl_thruk(){
  METHOD="${2:-GET}"
  cmd="command curl -X '$METHOD' \
            -H 'X-Thruk-Auth-Key: $AUTH_KEY' \
            -H 'X-Thruk-Auth-User: $AUTH_USER' \
            -sk 'http://localhost:$MY_ADAGIOS_PORT/thruk/r/$1'"
  eval $cmd
}
