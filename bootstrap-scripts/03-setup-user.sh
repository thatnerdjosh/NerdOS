#!/bin/sh

# FIXME: HACK for already created groups
groupadd lfs || true
useradd -s /bin/bash -g lfs -m -k /dev/null lfs || true
# passwd lfs
chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac

cp -rvf ./bootstrap-scripts/user-scripts/* /home/lfs

# Prevent env leakage while also passing a variable/calling a script
env -i LFS=$LFS su lfs -c './bootstrap-scripts/user-scripts/00-setup-env.sh'
