#!/bin/sh
# NerdOS Stage 3
export LFS=/mnt/lfs

echo "Building Stage3..."

./chroot-scripts/00-mount.sh

./bootstrap-scripts/05-birb.sh
