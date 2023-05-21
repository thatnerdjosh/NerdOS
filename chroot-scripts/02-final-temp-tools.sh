#!/bin/sh

export MAKEFLAGS="-j$(nproc)"

touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp

cd /sources
# Gettext
# 1 SBU
if test -f /usr/bin/xgettext; then
	echo "gettext already installed. skipping..."
else
	tar -xvf gettext-0.21.1.tar.xz
	cd gettext-0.21.1
	./configure --disable-shared
	make
	cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
	cd ..
fi

# Bison
# 0.2 SBU
if test -f /usr/bin/bison; then
	echo "bison already installed. skipping..."
else
	tar -xvf bison-3.8.2.tar.xz
	cd bison-3.8.2
	./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.8.2
	make
	make check
	make install
	cd ..
fi

# Perl
# 0.6 SBU
if test -f /usr/bin/perl; then
	echo "perl already installed. skipping..."
else
	tar -xvf perl-5.36.0.tar.xz
	cd perl-5.36.0
	sh Configure -des                                        \
             -Dprefix=/usr                               \
             -Dvendorprefix=/usr                         \
             -Dprivlib=/usr/lib/perl5/5.36/core_perl     \
             -Darchlib=/usr/lib/perl5/5.36/core_perl     \
             -Dsitelib=/usr/lib/perl5/5.36/site_perl     \
             -Dsitearch=/usr/lib/perl5/5.36/site_perl    \
             -Dvendorlib=/usr/lib/perl5/5.36/vendor_perl \
             -Dvendorarch=/usr/lib/perl5/5.36/vendor_perl

	make
	make install
	cd ..
fi

# Python
# 0.4 SBU
if test -f /usr/bin/python3; then
	echo "python already installed. skipping..."
else
	tar -xvf Python-3.11.2.tar.xz
	cd Python-3.11.2
	./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip
	make
	make install
	cd ..
fi

# Texinfo
# 0.2 SBU
if test -f /usr/bin/info; then
	echo "texinfo already installed. skipping..."
else
	tar -xvf texinfo-7.0.2.tar.xz
	cd texinfo-7.0.2
	./configure --prefix=/usr
	make
	make install
	cd ..
fi

# Util-linux
# 0.2 SBU
if test -f /usr/bin/lscpu; then
	echo "util-linux already installed. skipping..."
else
	tar -xvf util-linux-2.38.1.tar.xz
	cd util-linux-2.38.1
	mkdir -pv /var/lib/hwclock

	./configure ADJTIME_PATH=/var/lib/hwclock/adjtime    \
            --libdir=/usr/lib    \
            --docdir=/usr/share/doc/util-linux-2.38.1 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python     \
            runstatedir=/run

	make
	make install
	cd ..
fi

echo "Done installing temporary tools. Cleaning up..."

cd /
./03-cleanup.sh
