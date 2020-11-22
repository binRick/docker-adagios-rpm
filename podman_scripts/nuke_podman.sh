rm_all.sh

sudo dnf -y remove podman\*
time sudo rm -rf /var/lib/containers/cache /var/lib/containers/storage /var/lib/containers/sigstore

[[ -d .venv ]] && rm -rf .venv
