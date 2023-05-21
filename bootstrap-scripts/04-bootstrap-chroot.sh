#!/bin/sh

chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -R root:root $LFS/lib64 ;;
esac

cp -v ./chroot-scripts/* $LFS

mkdir -pv $LFS/{dev,proc,sys,run}
mount -v --bind /dev $LFS/dev
mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
else
  mount -t tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
fi

chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(NerdOS chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin \
    /01-chroot-install.sh

chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(NerdOS chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin \
    /02-final-temp-tools.sh

chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(NerdOS chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin \
    /03-cleanup.sh

#chroot "$LFS" /usr/bin/env -i   \
#    HOME=/root                  \
#    TERM="$TERM"                \
#    PS1='(NerdOS chroot) \u:\w\$ ' \
#    PATH=/usr/bin:/usr/sbin \
#    /bin/bash --login
