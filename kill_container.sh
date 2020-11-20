#sudo podman kill adagios; sudo podman rm adagios
#sudo podman ps -qa |xargs sudo podman kill
sudo podman ps -aq|xargs sudo podman kill
sudo podman ps -aq|xargs sudo podman rm
