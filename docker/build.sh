#!/bin/bash -e
##
## started with:
## $ docker run -ti -v $PWD/mnt:$(pwd)/output afb489d932bc
##
KDEFCONFIG=thinkpad-x1_6th-gen_20kh-ct01ww_defconfig

cp -arf ./linux-defconfigs/arch/x86_64/configs/$KDEFCONFIG ./linux/.config
cd linux
make clean
make-kpkg -j16 kernel-image modules-image kernel-headers --initrd

## obtain build artifacts
cp -arvf /root/*.deb /mnt/
