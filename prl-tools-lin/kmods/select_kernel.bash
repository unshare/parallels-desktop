#!/usr/bin/env bash
shopt -s expand_aliases extglob nullglob
set -o pipefail -xue

cd "$(dirname ${BASH_SOURCE[0]})"

make KERNEL_DIR=$PWD/kernel -f Makefile.kmods clean ||:
ln -sfT /usr/src/kernels/${1:?kernel not specified} ./kernel
make KERNEL_DIR=$PWD/kernel -f Makefile.kmods clean ||:
