#!/bin/bash -e
KDEFCONFIG=x86_64_thinkpad-x1_6th-gen_20kh-ct01ww_defconfig

cd linux
make clean
make $KDEFCONFIG
make-kpkg -j16 kernel-image modules-image kernel-headers --initrd

## obtain build artifacts
cp -arvf /root/*.deb /mnt/
