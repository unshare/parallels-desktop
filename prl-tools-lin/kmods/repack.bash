#!/usr/bin/env bash
shopt -s expand_aliases extglob nullglob
set -o pipefail -xue

cd "$(dirname ${BASH_SOURCE[0]})"

make -f Makefile.kmods clean

tarball=prl_mod.tar.gz
rm -f "$tarball"
tar zcvf "$tarball" \
    --exclude .gitignore --exclude .DS_Store \
    ./prl_* ./dkms.conf ./Makefile.kmods
