#!/bin/sh
set -e

BIRB_VERSION="main"
STOW_VERSION="2.3.1"

# TODO: Refactor test for file
if ! test -f $LFS/sources/birb-$BIRB_VERSION.tar.gz; then
    wget -O $LFS/sources/birb-$BIRB_VERSION.tar.gz https://github.com/Toasterbirb/birb/archive/refs/heads/$BIRB_VERSION.tar.gz
fi

if ! test -f $LFS/sources/stow-$STOW_VERSION.tar.gz; then
    wget -O $LFS/sources/stow-$STOW_VERSION.tar.gz http://ftp.gnu.org/gnu/stow/stow-2.3.1.tar.gz
fi

BUILD_DIR=$PWD
pushd $LFS/sources
    md5sum -c $BUILD_DIR/bootstrap-scripts/05-birb-checksum --strict
popd

if test -f $LFS/usr/bin/stow; then
    echo "Skipping stow install, already installed..."
else
    cd $LFS/sources
    tar -xvf stow-2.3.1.tar.gz
    cd stow-2.3.1

    ./configure --prefix=/usr
    make
    make DESTDIR=$LFS install

    cd $LFS/sources
    rm -rf stow-2.3.1
fi

if ! test -f $LFS/usr/bin/birb; then
	echo "Skipping birb install, already installed..."
else
    BIRB_SOURCE=birb-$BIRB_VERSION
    cd $LFS/sources
    # tar -xvf $BIRB_SOURCE.tar.gz
    cd $BIRB_SOURCE
    chmod +x bootstrap.sh

    # Initialize NerdOS-Packages repo
    mkdir -p ${LFS}/var/db/nerdos-pkg
    cd ${LFS}/var/db/nerdos-pkg
    git init
    git remote add origin https://github.com/thatnerdjosh/NerdOS-packages.git || true
    git fetch
    git checkout main
    cd -

    LFS=$LFS ./bootstrap.sh
    LFS=$LFS ./birb --download \
        man-pages \
        iana-etc \
        vim \
        zlib \
        bzip2 \
        xz \
        zstd \
        file \
        gmp \
        mpfr \
        ncurses \
        readline \
        m4 \
        bc \
        flex \
        tcl \
        expect \
        dejagnu \
        binutils \
        mpc \
        gcc \
        isl \
        attr \
        acl \
        libcap \
        shadow \
        pkg-config \
        sed \
        psmisc \
        gettext \
        bison \
        grep \
        bash \
        libtool \
        gdbm \
        gperf \
        expat \
        inetutils \
        less \
        perl \
        stow \
        xml-parser \
        intltool \
        autoconf \
        automake \
        openssl \
        kmod \
        libelf \
        libffi \
        python3 \
        flit-core \
        wheel \
        ninja \
        meson \
        coreutils \
        check \
        diffutils \
        gawk \
        findutils \
        groff \
        popt \
        mandoc \
        icu \
        libtasn1 \
        p11-kit \
        make-ca \
        curl \
        libarchive \
        libuv \
        libxml2 \
        nghttp2 \
        cmake \
        graphite2 \
        nspr \
        wget \
        nss \
        sqlite \
        gzip \
        iproute2 \
        kbd \
        libpipeline \
        make \
        patch \
        tar \
        texinfo \
        eudev \
        man-db \
        procps-ng \
        util-linux \
        e2fsprogs \
        sysklogd \
        sysvinit \
        freetype \
        harfbuzz \
        git

    chroot "$LFS" /usr/bin/env -i    \
        HOME="$PWD"                  \
        TERM="$TERM"                 \
        BIRB_SOURCE="$BIRB_SOURCE" \
        PATH=/usr/bin:/usr/sbin      \
        bash -c "./04-birb-setup.sh"
fi
