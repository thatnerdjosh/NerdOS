#!/bin/sh

cd /sources/$BIRB_SOURCE && make && make install

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
    stow \
    xml-parser \
    intltool \
    autoconf \
    automake \
    openssl \
    kmod \
    libelf \
    libffi \
    wget \
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
    sqlite \
    nspr \
    nss \
    make-ca \
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
yes | birb --install python3

# Handle the freetype2 and harfbuzz chickend/egg issue
birb --install --overwrite freetype harfbuzz freetype

# yes | birb --install --overwrite freetype
# yes | birb --install --overwrite harfbuzz
# yes | birb --install --overwrite freetype

## Reinstall graphite2 to add the freetype and harfbuzz functionality into it
yes | birb --install --overwrite graphite2
