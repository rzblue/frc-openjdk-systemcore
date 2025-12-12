#!/bin/bash
set -e
set -o pipefail

source versions.sh

JVM_VARIANT=server
JVM_FEATURES=
#JVM_VARIANT=minimal1
#JVM_FEATURES=all-gcs,jvmti,services,vm-structs

wget -nc https://github.com/openjdk/jdk21u/archive/refs/tags/${GIT_TAG}.tar.gz
tar xzf ${GIT_TAG}.tar.gz
pushd jdk21u-`echo ${GIT_TAG} | sed -e s/+/-/`
patch -p1 < ../config.guess.patch
patch -p1 < ../kill_on_abort.patch
patch -p1 < ../disable_mallinfo.patch
patch -p1 < ../error_log_timeout.patch
bash configure \
	--openjdk-target=aarch64-bookworm-linux-gnu \
	--with-extra-cflags="-mcpu=cortex-a76+crypto" \
	--with-extra-cxxflags="-mcpu=cortex-a76+crypto" \
	--with-jvm-variants=${JVM_VARIANT} \
	--with-jvm-features=${JVM_FEATURES} \
	--with-native-debug-symbols=zipped \
	--enable-unlimited-crypto \
	--with-sysroot=/usr/local/aarch64-linux-gnu/sysroot \
	--with-version-pre=frc \
	--with-version-patch=${JAVA_PATCH} \
	--with-version-opt=${YEAR}-${VER} \
	--disable-warnings-as-errors
make JOBS=`nproc` LOG=cmdlines all jdk-image
pushd build/linux-arm-${JVM_VARIANT}-release/images
tar czf jdk_${VER}.tar.gz jdk
chown -R `id -u`:`id -g` jre_${VER}.tar.gz
cp -a jdk_${VER}.tar.gz /artifacts
find jdk -name \*.diz -delete
find jdk -name \*.so -type f | xargs arm-frc${YEAR}-linux-gnueabi-strip
arm-frc${YEAR}-linux-gnueabi-strip jdk/bin/* jdk/lib/jexec
tar czf jdk_${VER}-strip.tar.gz jdk
chown -R `id -u`:`id -g` jdk_${VER}-strip.tar.gz
cp -a jdk_${VER}-strip.tar.gz /artifacts
popd
popd

rm -f control.tar.gz data.tar.gz
rm -rf jdk

tar xzf /artifacts/jdk_${VER}-strip.tar.gz
tar czf data.tar.gz \
    --transform "s,^jdk,usr/local/frc/JDK," \
    --owner=root \
    --group=root \
    jdk
tar czf control.tar.gz control postinst prerm
echo 2.0 > debian-binary
ar r /artifacts/${IPK_NAME} control.tar.gz data.tar.gz debian-binary
