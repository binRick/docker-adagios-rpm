#sudo podman kill adagios; sudo podman rm adagios
#sudo podman ps -qa |xargs sudo podman kill
(
  set +e
  sudo podman ps -aq|xargs sudo podman kill
  sudo podman ps -aq|xargs sudo podman rm
  sudo podman rm -f adagios
) 2>/dev/null
