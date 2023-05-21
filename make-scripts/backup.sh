mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm
umount $LFS/dev/pts
umount $LFS/{sys,proc,run,dev}
rm -rf $LFS/sources/*/

cd $LFS
XZ_OPT='-T0 --memlimit=90%' tar -cJpf nerdos-backup.tar.xz .
