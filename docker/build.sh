#!/bin/bash -e
export KDEFCONFIG=x86_64_thinkpad-x1_6th-gen_20kh-ct01ww_defconfig
export MY_HOME="/home/$(whoami)"

cd linux
make clean
make $KDEFCONFIG
make-kpkg -j16 kernel-image modules-image kernel-headers --initrd

sudo chown $(whoami).$(whoami) -R ${MY_HOME}/output
cp -arvf ${MY_HOME}/*.deb ${MY_HOME}/output/
