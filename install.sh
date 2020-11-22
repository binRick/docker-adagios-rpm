source setup.sh
pip3 install \
	'j2cli[yaml]' \
--user --upgrade

sudo dnf -y remove docker\*
sudo dnf -y install podman;
