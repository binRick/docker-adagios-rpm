set +ex

if [[ "$(sudo podman ps -aq|wc -l)" == "0" ]]; then
  exit 0
fi
#sudo podman kill adagios; sudo podman rm adagios
#sudo podman ps -qa |xargs sudo podman kill
sudo podman ps -aq|xargs sudo podman kill
sudo podman ps -aq|xargs sudo podman rm
