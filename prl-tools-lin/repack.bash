#!/usr/bin/env bash
shopt -s expand_aliases extglob nullglob
set -o pipefail -xue

cd "$(dirname ${BASH_SOURCE[0]})"

kmods/repack.bash
trap 'rm -rf "$tmp_dir"' INT TERM ERR EXIT
tmp_dir="$(mktemp -d)"
rsync -av ./ "$tmp_dir/" --filter ". /dev/stdin" <<-EOF
	- .gitignore
	- .DS_Store
	- /.vscode/
	+ kmods/prl_mod.tar.gz
	- kmods/*
	- *.bash
EOF
genisoimage -rv -o ../prl-tools-lin-fixed.iso "$tmp_dir"
