nodemon \
	-w container-adagios-compose.yaml \
	-w centos_build/Dockerfile.fedora33 \
	-w fedora_build.sh \
	-w centos_build/Dockerfile.fedora33 \
	-V \
	-x time ./build_adagios_image.sh
