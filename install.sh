
python3 -m venv .venv
source .venv/bin/activate
pip3 install \
	j2cli \
--user --upgrade

sudo dnf -y remove docker\*
sudo dnf -y install podman;
