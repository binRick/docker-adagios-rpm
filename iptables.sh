
sudo iptables -I FORWARD -j ACCEPT

sudo iptables -I INPUT -i cni-podman0 -j ACCEPT

