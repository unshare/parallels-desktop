#!/usr/bin/env bash
shopt -s expand_aliases extglob nullglob
set -o pipefail -xue

cd "$(dirname ${BASH_SOURCE[0]})"

kmods/repack.bash
sudo ./install --install --install-unattended-with-deps --progress --verbose
