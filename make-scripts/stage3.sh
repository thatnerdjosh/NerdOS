#!/bin/sh
# NerdOS Stage 3

if [ -z ${LFS+x} ]; then
  export LFS=/mnt/lfs
fi

echo "Building Stage3..."

./chroot-scripts/00-mount.sh

./bootstrap-scripts/05-birb.sh
