nodemon \
	-w container-adagios-compose.yaml \
	-w fedora_build.sh \
	-w centos_build/Dockerfile.fedora33 \
    -w . \
	-V \
	-e fedora33,sh,yaml \
    -i RPM_CACHE/ \
    --delay .5 \
	-x time ./build_adagios_image.sh
