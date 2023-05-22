#!/bin/sh

chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -R root:root $LFS/lib64 ;;
esac

./chroot-scripts/00-mount.sh
cp -v ./chroot-scripts/* $LFS

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
