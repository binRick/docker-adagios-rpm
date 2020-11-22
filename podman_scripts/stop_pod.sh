

sudo podman pod exists $MY_POD_UUID || true
sudo podman pod stop $MY_POD_UUID || true

