#!/bin/bash
set -e
AUTH_USER=thrukadmin
AUTH_KEY="$(./get_container_key.sh)"

source curl_thruk.sh

curl_thruk 'thruk/api_keys' POST  | python -m json.tool | grep '"private_key":' | cut -d'"' -f4
