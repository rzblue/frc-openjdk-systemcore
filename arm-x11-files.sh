#!/bin/bash
set -e
set -o pipefail

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

prefix=$(realpath "$1") # prefix for the installation directory
download_dir=$(realpath "arm-x11-files-download")

mkdir -p "$download_dir"
pushd "$download_dir"
wget -nc http://http.us.debian.org/debian/pool/main/x/xorgproto/x11proto-dev_2022.1-1_all.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxrandr/libxrandr-dev_1.5.2-2+b1_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxrandr/libxrandr2_1.5.2-2+b1_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxext/libxext-dev_1.3.4-1+b1_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxext/libxext6_1.3.4-1+b3_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libx11/libx11-dev_1.8.4-2+deb12u2_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libx11/libx11-6_1.8.4-2+deb12u2_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxcb/libxcb1-dev_1.15-1_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxcb/libxcb1_1.15-1_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxau/libxau-dev_1.0.9-1_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxau/libxau6_1.0.9-1_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxdmcp/libxdmcp-dev_1.1.2-3_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxdmcp/libxdmcp6_1.1.2-3_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libb/libbsd/libbsd0_0.11.7-2_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxrender/libxrender1_0.9.10-1.1_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxrender/libxrender-dev_0.9.10-1.1_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxfixes/libxfixes-dev_6.0.0-2_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxfixes/libxfixes3_6.0.0-2_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxi/libxi-dev_1.8-1+b1_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxi/libxi6_1.8-1+b1_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxt/libxt-dev_1.2.1-1.1_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxt/libxt6_1.2.1-1.1_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libs/libsm/libsm-dev_1.2.3-1_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libs/libsm/libsm6_1.2.3-1_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libi/libice/libice-dev_1.0.10-1_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libi/libice/libice6_1.0.10-1_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/i/iptables/libxtables-dev_1.8.9-2_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/i/iptables/libxtables12_1.8.9-2_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxtst/libxtst-dev_1.2.3-1.1_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxtst/libxtst6_1.2.3-1.1_arm64.deb
wget -nc http://http.us.debian.org/debian/pool/main/x/xorg/x11-common_7.7+23_all.deb
wget -nc http://http.us.debian.org/debian/pool/main/x/xtrans/xtrans-dev_1.4.0-1_all.deb
wget -nc http://http.us.debian.org/debian/pool/main/u/util-linux/libuuid1_2.38.1-5+deb12u3_arm64.deb
popd

mkdir -p "$download_dir/sysroot"
pushd "$download_dir/sysroot"
    for file in "$download_dir"/*.deb; do
        ar p $file data.tar.xz | tar xJf -
    done
    rm -rf etc usr/bin usr/share usr/lib/aarch64-linux-gnu/pkgconfig usr/lib/X11
    # mv usr/lib/aarch64-linux-gnu/* usr/lib/
    # rmdir usr/lib/aarch64-linux-gnu
popd
cp -r "$download_dir"/sysroot/* "$prefix"/
