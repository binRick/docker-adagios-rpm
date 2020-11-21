sudo podman images -q | xargs -I % sudo podman image rm %
