
python3 -m venv .venv
source .venv/bin/activate
pip3 install \
	j2cli \
--user --upgrade

dnf -y remove docker\*
dnf -y install podman;
