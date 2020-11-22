sudo podman pod ps -q|xargs -I % sudo podman pod rm %
