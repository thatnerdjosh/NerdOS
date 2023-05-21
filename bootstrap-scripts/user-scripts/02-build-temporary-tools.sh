#!/bin/sh

. ~/.bashrc

cd $LFS/sources

# M4
# 0.1 SBU
if test -f $LFS/usr/bin/m4; then
	echo "m4 already installed. skipping..."
else
	tar -xvf m4-1.4.19.tar.xz
	cd m4-1.4.19
	./configure --prefix=/usr   \
		    --host=$LFS_TGT \
		    --build=$(build-aux/config.guess)
	make
	make DESTDIR=$LFS install
	cd $LFS/sources
	rm -rf m4-1.4.19
fi

# Ncurses
# 0.3 SBU
if test -f $LFS/usr/lib/libncurses.so; then
	echo "ncurses already installed. skipping..."
else
	tar -xvf ncurses-6.4.tar.gz
	cd ncurses-6.4
	sed -i s/mawk// configure
	mkdir build
	pushd build
	  ../configure
	  make -C include
	  make -C progs tic
	popd
	./configure --prefix=/usr                \
		    --host=$LFS_TGT              \
		    --build=$(./config.guess)    \
		    --mandir=/usr/share/man      \
		    --with-manpage-format=normal \
		    --with-shared                \
		    --without-normal             \
		    --with-cxx-shared            \
		    --without-debug              \
		    --without-ada                \
		    --disable-stripping          \
		    --enable-widec
	make
	make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install
	echo "INPUT(-lncursesw)" > $LFS/usr/lib/libncurses.so
	cd $LFS/sources
	rm -rf ncurses-6.4
fi

# Bash
# 0.2 SBU
if test -f $LFS/bin/bash; then
	echo "bash already installed. skipping..."
else
	tar -xvf bash-5.2.15.tar.gz
	cd bash-5.2.15
	./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc
	make
	make DESTDIR=$LFS install
	ln -sv bash $LFS/bin/sh
	cd $LFS/sources
	rm -rf bash-5.2.15
fi


# Coreutils
# 0.3 SBU
if test -d $LFS/usr/libexec/coreutils; then
	echo "coreutils already installed. skipping..."
else
	tar -xvf coreutils-9.1.tar.xz
	cd coreutils-9.1
	./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime
	make
	make DESTDIR=$LFS install
	mv -v $LFS/usr/bin/chroot              $LFS/usr/sbin
	mkdir -pv $LFS/usr/share/man/man8
	mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
	sed -i 's/"1"/"8"/'                    $LFS/usr/share/man/man8/chroot.8
	cd $LFS/sources
	rm -rf coreutils-9.1

fi

# Diffutils
if test -f $LFS/usr/bin/diff; then
	echo "diffutils already installed. skipping..."
else
	tar -xvf diffutils-3.9.tar.xz
	cd diffutils-3.9
	./configure --prefix=/usr --host=$LFS_TGT
	make
	make DESTDIR=$LFS install
	cd $LFS/sources
	rm -rf diffutils-3.9
fi

# File
if test -f $LFS/usr/bin/file; then
	echo "file already installed. skipping..."
else
	tar -xvf file-5.44.tar.gz
	cd file-5.44
	mkdir build
	pushd build
	  ../configure --disable-bzlib      \
		       --disable-libseccomp \
		       --disable-xzlib      \
		       --disable-zlib
	  make
	popd
	./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)
	make FILE_COMPILE=$(pwd)/build/src/file
	make DESTDIR=$LFS install
	rm -v $LFS/usr/lib/libmagic.la
	cd $LFS/sources
	rm -rf file-5.44
fi

# Findutils
if test -f $LFS/usr/bin/find; then
	echo "findutils already installed. skipping..."
else
	tar -xvf findutils-4.9.0.tar.xz
	cd findutils-4.9.0
	./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)
	make
	make DESTDIR=$LFS install
	cd $LFS/sources
	rm -rf findutils-4.9.0
fi

# Gawk
if test -f $LFS/usr/bin/awk; then
	echo "gawk already installed. skipping..."
else
	tar -xvf gawk-5.2.1.tar.xz
	cd gawk-5.2.1
	sed -i 's/extras//' Makefile.in
	./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
	make
	make DESTDIR=$LFS install
	cd $LFS/sources
	rm -rf gawk-5.2.1
fi

# Grep
if test -f $LFS/usr/bin/grep; then
	echo "grep already installed. skipping..."
else
	tar -xvf grep-3.8.tar.xz
	cd grep-3.8
	
	./configure --prefix=/usr   \
		    --host=$LFS_TGT
	make
	make DESTDIR=$LFS install
	cd $LFS/sources
	rm -rf grep-3.8

fi

# Gzip
if test -f $LFS/usr/bin/gzip; then
	echo "gzip already installed. skipping..."
else
	tar -xvf gzip-1.12.tar.xz
	cd gzip-1.12
	./configure --prefix=/usr --host=$LFS_TGT
	make
	make DESTDIR=$LFS install
	cd $LFS/sources
	rm -rf gzip-1.12
fi

# Make
# less than 0.1 SBU
if test -f $LFS/usr/bin/make; then
	echo "make already installed. skipping..."
else
	tar -xvf make-4.4.tar.gz
	cd make-4.4
	sed -e '/ifdef SIGPIPE/,+2 d' \
	    -e '/undef  FATAL_SIG/i FATAL_SIG (SIGPIPE);' \
	    -i src/main.c
	./configure --prefix=/usr   \
            --without-guile \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
	make
	make DESTDIR=$LFS install
	cd $LFS/sources
	rm -rf make-4.4
fi

# Patch
# 0.1 SBU
if test -f $LFS/usr/bin/patch; then
	echo "patch already installed. skipping..."
else
	tar -xvf patch-2.7.6.tar.xz
	cd patch-2.7.6
	./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
	make
	make DESTDIR=$LFS install
	cd $LFS/sources
	rm -rf patch-2.7.6
fi

# Sed
# 0.2 SBU
if test -f $LFS/usr/bin/sed; then
	echo "sed already installed. skipping..."
else
	tar -xvf sed-4.9.tar.xz
	cd sed-4.9
	./configure --prefix=/usr   \
            --host=$LFS_TGT
	make
	make DESTDIR=$LFS install
	cd $LFS/sources
	rm -rf sed-4.9
fi

# Tar
# 0.1 SBU
if test -f $LFS/usr/bin/tar; then
	echo "tar already installed. skipping..."
else
	tar -xvf tar-1.34.tar.xz
	cd tar-1.34
	./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess)
	make
	make DESTDIR=$LFS install
	cd $LFS/sources
	rm -rf tar-1.34
fi

# Xz
# 0.1 SBU
if test -f $LFS/usr/bin/xz; then
	echo "xz already installed. skipping..."
else
	tar -xvf xz-5.4.1.tar.xz
	cd xz-5.4.1
	./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.4.1
	make
	make DESTDIR=$LFS install
	rm -v $LFS/usr/lib/liblzma.la
	cd $LFS/sources
	rm -rf xz-5.4.1
fi

# Binutils (pass 2)
# 0.4 SBU
if test -f $LFS/usr/bin/as; then
	echo "binutils already installed. skipping..."
else
	tar -xvf binutils-2.40.tar.xz
	cd binutils-2.40
	sed '6009s/$add_dir//' -i ltmain.sh
	rm -rf build
	mkdir -v build
	cd       build
	../configure                   \
	    --prefix=/usr              \
	    --build=$(../config.guess) \
	    --host=$LFS_TGT            \
	    --disable-nls              \
	    --enable-shared            \
	    --enable-gprofng=no        \
	    --disable-werror           \
	    --enable-64-bit-bfd
	make
	make DESTDIR=$LFS install
	rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.{a,la}
	cd $LFS/sources
	rm -rf binutils-2.40
fi

# GCC (pass 2)
# 4.6 SBU
if test -f $LFS/usr/bin/gcc; then
	echo "gcc already installed. skipping..."
else
    tar -xf gcc-12.2.0.tar.xz
	cd gcc-12.2.0
	tar -xf ../mpfr-4.2.0.tar.xz
	mv -v mpfr-4.2.0 mpfr
	tar -xf ../gmp-6.2.1.tar.xz
	mv -v gmp-6.2.1 gmp
	tar -xf ../mpc-1.3.1.tar.gz
	mv -v mpc-1.3.1 mpc


	case $(uname -m) in
	  x86_64)
	    sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
	  ;;
	esac
	sed '/thread_header =/s/@.*@/gthr-posix.h/' \
	    -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in
	rm -rf build
	mkdir -v build
	cd       build
	../configure                                       \
	    --build=$(../config.guess)                     \
	    --host=$LFS_TGT                                \
	    --target=$LFS_TGT                              \
	    LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc      \
	    --prefix=/usr                                  \
	    --with-build-sysroot=$LFS                      \
	    --enable-default-pie                           \
	    --enable-default-ssp                           \
	    --disable-nls                                  \
	    --disable-multilib                             \
	    --disable-libatomic                            \
	    --disable-libgomp                              \
	    --disable-libquadmath                          \
	    --disable-libssp                               \
	    --disable-libvtv                               \
	    --enable-languages=c,c++
	make
	make DESTDIR=$LFS install
	ln -sv gcc $LFS/usr/bin/cc
fi
