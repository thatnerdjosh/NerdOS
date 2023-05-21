#!/bin/sh

# TODO: Find a way to use a login shell in the script.
. ~/.bashrc

cd $LFS/sources

# TODO: Figure out a better way to handle checking if we should compile
# ^ We can just use an installation progress file like BirbOS does
# Binutils
# 1 SBU == ~47 seconds
if test -f $LFS/tools/$LFS_TGT/bin/ld; then
	echo "Skipping binutils compile, already compiled..."
else
	tar -xvf binutils-2.40.tar.xz
	cd binutils-2.40
	mkdir -v build
	cd build
	../configure --prefix=$LFS/tools \
		     --with-sysroot=$LFS \
		     --target=$LFS_TGT   \
		     --disable-nls       \
		     --enable-gprofng=no \
		     --disable-werror
	make
	make install
	cd $LFS/sources
	rm -rf binutils-2.40
fi

# GCC
# 3.3 SBU
if test -f $LFS/tools/bin/$LFS_TGT-gcc; then
	echo "Skipping GCC compile, already compiled..."
else
	tar -xvf gcc-12.2.0.tar.xz
	cd gcc-12.2.0

	tar -xvf ../mpfr-4.2.0.tar.xz
	mv -v mpfr-4.2.0 mpfr
	tar -xvf ../gmp-6.2.1.tar.xz
	mv -v gmp-6.2.1 gmp
	tar -xvf ../mpc-1.3.1.tar.gz
	mv -v mpc-1.3.1 mpc

	case $(uname -m) in
	  x86_64)
	    sed -e '/m64=/s/lib64/lib/' \
		-i.orig gcc/config/i386/t-linux64
	 ;;
	esac

	mkdir -v build
	cd build
	../configure                  \
	    --target=$LFS_TGT         \
	    --prefix=$LFS/tools       \
	    --with-glibc-version=2.37 \
	    --with-sysroot=$LFS       \
	    --with-newlib             \
	    --without-headers         \
	    --enable-default-pie      \
	    --enable-default-ssp      \
	    --disable-nls             \
	    --disable-shared          \
	    --disable-multilib        \
	    --disable-threads         \
	    --disable-libatomic       \
	    --disable-libgomp         \
	    --disable-libquadmath     \
	    --disable-libssp          \
	    --disable-libvtv          \
	    --disable-libstdcxx       \
	    --enable-languages=c,c++
	make
	make install
	cd ..
	cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
	  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/install-tools/include/limits.h
	cd $LFS/sources
	rm -rf gcc-12.2.0
fi

# Linux Headers
# 0.1 SBU
if test -d $LFS/usr/include; then
	echo "Skipping linux headers, already exists..."
else
	tar -xvf linux-6.1.11.tar.xz
	cd linux-6.1.11
	make mrproper
	make headers
	find usr/include -type f ! -name '*.h' -delete
	cp -rv usr/include $LFS/usr
	cd $LFS/sources
	rm -rf linux-6.1.11
fi

# Glibc
# 1.5 SBU
if test -f $LFS/usr/bin/ldd; then
	echo "Skipping Glibc, alread installed..."
else
	tar -xvf glibc-2.37.tar.xz
	cd glibc-2.37

	case $(uname -m) in
	    i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
	    ;;
	    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
		    ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
	    ;;
	esac

	patch -Np1 -i ../glibc-2.37-fhs-1.patch

	mkdir -v build
	cd build
	echo "rootsbindir=/usr/sbin" > configparms
	../configure                             \
	      --prefix=/usr                      \
	      --host=$LFS_TGT                    \
	      --build=$(../scripts/config.guess) \
	      --enable-kernel=3.2                \
	      --with-headers=$LFS/usr/include    \
	      libc_cv_slibdir=/usr/lib
	make
	make DESTDIR=$LFS install
	sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd
	echo 'int main(){}' | $LFS_TGT-gcc -xc -
	readelf -l a.out | grep ld-linux
	rm -v a.out
	$LFS/tools/libexec/gcc/$LFS_TGT/12.2.0/install-tools/mkheaders
	cd $LFS/sources
	rm -rf glibc-2.37
fi

# Libstdc++
# 0.2 SBU
if test -d $LFS/tools/$LFS_TGT/include/c++/12.2.0; then
	echo "libstdc++ already available. skipping..."
else
	tar -xvf gcc-12.2.0.tar.xz
	cd gcc-12.2.0
	rm -rf build
	mkdir -v build
	cd build
	../libstdc++-v3/configure           \
	    --host=$LFS_TGT                 \
	    --build=$(../config.guess)      \
	    --prefix=/usr                   \
	    --disable-multilib              \
	    --disable-nls                   \
	    --disable-libstdcxx-pch         \
	    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/12.2.0
	make
	make DESTDIR=$LFS install
	rm -v $LFS/usr/lib/lib{stdc++,stdc++fs,supc++}.la
	cd $LFS/sources
	rm -rf gcc-12.2.0
fi
