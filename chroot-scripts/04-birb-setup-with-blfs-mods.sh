#!/bin/sh

set -e

cd /sources/$BIRB_SOURCE && make && make install

# NerdOS isn't yet multilib
sed -i 's/abi_x86_32//' /etc/birb.conf

# Add NerdOS package source
sed -i 's/birb-core;/nerdos;https:\/\/github.com\/thatnerdjosh\/NerdOS-packages;\/var\/db\/nerdos-pkg\nbirb-core;/' /etc/birb-sources.conf

yes 'n' | birb --install --overwrite \
    man-pages \
    iana-etc \
    vim \
    zlib \
    bzip2 \
    xz \
    zstd \
    file \
    pkg-config \
    ncurses \
    readline \
    m4 \
    bc \
    flex \
    tcl \
    expect \
    dejagnu \
    binutils \
    gmp \
    mpfr \
    mpc \
    isl \
    attr \
    acl \
    libcap \
    shadow \
    gcc \
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
    stow

# FIXME: After stow was re-installed, there is some error post-install for these two. They seem to install fine.
yes 'n' | birb --install --overwrite xml-parser
yes 'n' | birb --install --overwrite intltool
yes 'n' | birb --install --overwrite \
    autoconf \
    automake \
    openssl \
    kmod \
    libelf \
    sqlite \
    libtasn1 \
    python3 \
    flit-core \
    wheel \
    ninja \
    meson \
    p11-kit \
    nspr \
    nss \
    make-ca \
    libffi \
    wget \
    coreutils \
    check \
    diffutils \
    gawk \
    findutils \
    groff \
    popt \
    mandoc \
    icu \
    curl \
    libarchive \
    libuv \
    libxml2 \
    nghttp2 \
    cmake \
    graphite2 \
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
    sysvinit

# Python3 needs to be recompiled after sqlite is installed. Otherwise firefox won't compile
# yes | birb --install python3

# Handle the freetype2 and harfbuzz chicken/egg issue
yes | birb --install --overwrite freetype harfbuzz
yes | birb --install --overwrite freetype

## Reinstall graphite2 to add the freetype and harfbuzz functionality into it
yes | birb --install --overwrite graphite2
