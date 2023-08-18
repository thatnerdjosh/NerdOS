#!/bin/sh
set -e

su - lfs -s './02-build-temporary-tools.sh'

./bootstrap-scripts/04-bootstrap-chroot.sh

# TODO: Move to unmount script
mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm
umount $LFS/dev/pts
umount $LFS/{sys,proc,run,dev}
rm -rf $LFS/sources/*/

XZ_OPT='-T0 --memlimit=90%' tar -cJpf $REPO_DIR/NerdOS-lfs-stage2-11.3.tar.xz $LFS
