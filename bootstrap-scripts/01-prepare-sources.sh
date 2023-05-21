#!/bin/sh

# TODO: Refactor mounting
if [ ! -d $LFS ]; then
  mkdir -pv $LFS

  umount -R $LFS
  mount -v -t ext4 /dev/sda4 $LFS

  mkdir -pv $LFS/home
  mount -v -t ext4 /dev/sda3 $LFS/home

  mkdir -pv $LFS/boot
  mount -v -t ext2 /dev/sda2 $LFS/boot
fi

mkdir -pv $LFS/sources
chmod -v a+wt $LFS/sources

mkdir -pv build
cd build

# Get packages from package list
wget --continue https://www.linuxfromscratch.org/lfs/view/stable/wget-list-sysv

# TODO: clean this up
if test `find /mnt/lfs/sources/ -maxdepth 1 -type f | wc -l` != `cat wget-list-sysv | wc -l`; then
  wget --input-file=wget-list-sysv --continue --directory-prefix=$LFS/sources
fi

# Get checksums
BUILD_DIR=$PWD
wget --continue https://www.linuxfromscratch.org/lfs/view/stable/md5sums
pushd $LFS/sources
  md5sum -c $BUILD_DIR/md5sums
popd
chown root:root $LFS/sources/*
cd ..
