
#[[ "$BUILD_USER" != "" ]] && sudo chown $BUILD_USER . -R

[[ -d .venv ]] || python3 -m venv .venv

source .venv/bin/activate

[[ -f .envrc ]] || decrypt_envrc.sh
[[ -f .envrc ]] || exit 1
