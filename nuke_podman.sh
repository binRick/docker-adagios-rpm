
sudo dnf -y remove podman\*
time sudo rm -rf /var/lib/containers/cache /var/lib/containers/storage

[[ -d .venv ]] && rm -rf .venv
