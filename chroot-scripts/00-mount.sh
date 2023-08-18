#!/bin/sh

mkdir -pv $LFS/{dev,proc,sys,run}
mount -v --onlyonce --bind /dev $LFS/dev
mount -v --onlyonce --bind /dev/pts $LFS/dev/pts
mount -vt --onlyonce proc proc $LFS/proc
mount -vt --onlyonce sysfs sysfs $LFS/sys
mount -vt --onlyonce tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv --onlyonce $LFS/$(readlink $LFS/dev/shm)
else
  mount --onlyonce -t tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
fi
