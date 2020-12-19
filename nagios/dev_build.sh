#!/bin/bash

command nodemon \
	-w container-adagios-compose.yaml \
	-w centos_build/Dockerfile.fedora33 \
    -w . \
    -w rpms/ \
	-V \
	-e fedora33,sh,yaml,rpm \
    -i RPM_CACHE/ \
    --delay .5 \
	-x time ./build_adagios_image.sh $@
