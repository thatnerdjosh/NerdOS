#!/bin/sh
set -e

export LFS=/mnt/lfs

su - lfs -s './02-build-temporary-tools.sh'

./bootstrap-scripts/04-bootstrap-chroot.sh

mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm
umount $LFS/dev/pts
umount $LFS/{sys,proc,run,dev}
rm -rf $LFS/sources/*/

REPO_DIR=$PWD
cd $LFS
XZ_OPT='-T0 --memlimit=90%' tar -cJpf NerdOS-lfs-stage2-11.3.tar.xz .

mv NerdOS-lfs-stage2-11.3.tar.xz $REPO_DIR