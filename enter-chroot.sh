export LFS=/home/josh/stages/stages/stage2

mkdir -pv $LFS/{dev,proc,sys,run}
# TODO: use 00-mount pls, thx
mount --onlyonce -v --bind /dev $LFS/dev
mount --onlyonce -v --bind /dev/pts $LFS/dev/pts
mount --onlyonce -vt proc proc $LFS/proc
mount --onlyonce -vt sysfs sysfs $LFS/sys
mount --onlyonce -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir --onlyonce -pv $LFS/$(readlink $LFS/dev/shm)
else
  mount --onlyonce -t tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
fi

chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(NerdOS chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin \
    /bin/bash --login
