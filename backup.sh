if [ -z ${STAGE+x} ]; then echo "\$STAGE not set, please set and then re-run..." && exit 1; fi

mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm
umount $LFS/dev/pts
umount $LFS/{sys,proc,run,dev}
rm -rf $LFS/sources/*/

cd $LFS
XZ_OPT='-T0 --memlimit=90%' tar -cJpf nerdos-lfs-stage${STAGE}-11.3.tar.xz .
