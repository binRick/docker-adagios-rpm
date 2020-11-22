eval $(cat setup.sh)
pip3 install \
	'j2cli[yaml]' \
--user --upgrade

sudo dnf -y remove docker docker-common
sudo dnf -y install podman
