nodemon \
	-w container-adagios-compose.yaml \
	-w fedora_build.sh \
	-w centos_build/Dockerfile.fedora33 \
	-V \
	-e fedora33,sh,yaml \
	-x time ./build_adagios_image.sh
