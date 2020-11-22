safeu --decrypt .envrc.enc --output .envrc && direnv allow .
md5sum .envrc*
ls -altr .envrc*
