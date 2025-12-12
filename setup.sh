#!/bin/bash
set -e
set -o pipefail

source versions.sh

apt-get update && apt-get install -y \
    autoconf \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    file \
    g++ --no-install-recommends \
    gcc \
    gdb \
    git \
    java-common \
    libc6-dev \
    libcups2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libisl23 \
    libpython2.7 \
    libx11-dev \
    libxext-dev \
    libxrandr-dev \
    libxrender-dev \
    libxtst-dev \
    libxt-dev \
    make \
    unzip \
    wget \
    zip

curl -SL https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-16.0.2_linux-x64_bin.tar.gz | sh -c 'cd /usr/lib/jvm && tar xzf -'
cp jdk-16.jinfo /usr/lib/jvm/.jdk-16.0.2.jinfo
grep /usr/lib/jvm /usr/lib/jvm/.jdk-16.0.2.jinfo \
    | awk '{ print "update-alternatives --install /usr/bin/" $2 " " $2 " " $3 " 2"; }' \
    | bash
update-java-alternatives -s jdk-16.0.2

# Add ARM files for x11 (not Systemcore, but doesn't have to be)
./arm-x11-files.sh /usr/local/aarch64-linux-gnu/sysroot

# Add cross libraries
wget \
    http://http.us.debian.org/debian/pool/main/a/alsa-lib/libasound2_1.2.8-1+b1_arm64.deb \
    http://http.us.debian.org/debian/pool/main/a/alsa-lib/libasound2-dev_1.2.8-1+b1_arm64.deb \
    http://http.us.debian.org/debian/pool/main/c/cups/libcups2_2.4.2-3+deb12u9_arm64.deb \
    http://http.us.debian.org/debian/pool/main/c/cups/libcups2-dev_2.4.2-3+deb12u9_arm64.deb \
    http://http.us.debian.org/debian/pool/main/z/zlib/zlib1g_1.2.13.dfsg-1_arm64.deb \
    http://http.us.debian.org/debian/pool/main/f/freetype/libfreetype6_2.12.1+dfsg-5+deb12u4_arm64.deb \
    http://http.us.debian.org/debian/pool/main/f/freetype/libfreetype6-dev_2.12.1+dfsg-5+deb12u4_arm64.deb \
    http://http.us.debian.org/debian/pool/main/f/fontconfig/libfontconfig1_2.14.1-4_arm64.deb \
    http://http.us.debian.org/debian/pool/main/f/fontconfig/libfontconfig-dev_2.14.1-4_arm64.deb \

for f in *.deb; do \
    ar p $f data.tar.xz | sh -c "cd /usr/local/aarch64-linux-gnu/sysroot && tar xJf -"; \
done

