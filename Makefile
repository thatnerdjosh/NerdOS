OS := NerdOS
LFS_VERSION := 11.3
LFS := /mnt/lfs

all: clean stage1 stage2 # stage3

clean:
	mountpoint -q $(LFS)/dev/shm && umount $(LFS)/dev/shm || true
	umount $(LFS)/dev/pts || true
	umount $(LFS)/{sys,proc,run,dev} || true
	umount $(LFS)/boot || true
	umount $(LFS)/home || true
	rm -rf $(LFS)/*

stage1: stages/$(OS)-lfs-stage1-$(LFS_VERSION).tar.xz
.PHONY: stage1

stage2: stages/$(OS)-lfs-stage2-$(LFS_VERSION).tar.xz
.PHONY: stage2

stage3: stages/$(OS)-lfs-stage3-$(LFS_VERSION).tar.xz
.PHONY: stage3

stages/$(OS)-lfs-stage1-$(LFS_VERSION).tar.xz:
	./make-scripts/stage1.sh

stages/$(OS)-lfs-stage2-$(LFS_VERSION).tar.xz:
	./make-scripts/stage2.sh

stages/$(OS)-lfs-stage3-$(LFS_VERSION).tar.xz:
	./make-scripts/stage3.sh
