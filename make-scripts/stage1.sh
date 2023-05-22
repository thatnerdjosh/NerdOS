# NerdOS Stage 1
export LFS=/mnt/lfs
. ./functions.sh

echo "Building Stage1..."
./bootstrap-scripts/00-version-check.sh
./bootstrap-scripts/01-prepare-sources.sh
./bootstrap-scripts/02-prepare-rootfs.sh
./bootstrap-scripts/03-setup-user.sh
su - lfs -s './01-build-cross-toolchain.sh'

REPO_DIR=$PWD

echo "Compressing Stage1 Archive..."
XZ_OPT='-T0 --memlimit=90%' tar -cJpf $REPO_DIR/NerdOS-lfs-stage1-11.3.tar.xz $LFS