#!/usr/bin/env bash
shopt -s expand_aliases extglob nullglob
set -o pipefail -xue

cd "$(dirname ${BASH_SOURCE[0]})"

make KERNEL_DIR=$PWD/kernel -f Makefile.kmods clean ||:
ln -sfT /usr/src/kernels/${1:?kernel not specified} ./kernel
ln -sf prl_drm_flags-$1.h ./prl_vid/Video/Guest/Linux/kmod/prl_drm_flags.h
make KERNEL_DIR=$PWD/kernel -f Makefile.kmods clean ||:
