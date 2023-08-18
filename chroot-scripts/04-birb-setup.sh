#!/bin/sh

set -e

cd /sources/$BIRB_SOURCE && make && make install

# NerdOS isn't yet multilib
sed -i 's/abi_x86_32//' /etc/birb.conf

# Add NerdOS package source
# TODO: Add conditional
sed -i 's/birb-core;/nerdos;https:\/\/github.com\/thatnerdjosh\/NerdOS-packages;\/var\/db\/nerdos-pkg\nbirb-core;/' /etc/birb-sources.conf

yes 'n' | birb --install --overwrite \
    man-pages \
    iana-etc

# Break from Birb to compile glibc again (not packaged with Birb)

yes 'n' | birb --install --overwrite \
    zlib \
    bzip2 \
    xz \
    zstd \
    file \
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
    attr \
    acl \
    libcap \
    shadow \
    gcc \
    pkg-config \
    ncurses \
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
    libffi \
    python3 \
    wheel \
    ninja \
    meson \
    coreutils \
    check \
    diffutils \
    gawk \
    findutils \
    groff \
    gzip \
    iproute2 \
    libpipeline \
    make \
    patch \
    tar \
    texinfo \
    vim \
    eudev \
    man-db \
    procps-ng \
    util-linux \
    e2fsprogs \
    sysklogd \
    sysvinit
