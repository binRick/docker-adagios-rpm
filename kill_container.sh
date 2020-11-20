sudo podman kill adagios; podman rm adagios
sudo podman ps -qa |xargs sudo podman kill
