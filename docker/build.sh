#!/bin/bash -e
export KDEFCONFIG=x86_64__v5.5__thinkpad-x1_6th-gen_20kh-ct01ww_defconfig
export MY_HOME="/home/$(whoami)"

cd ${MY_HOME}/linux
make clean
make $KDEFCONFIG
make -j16 deb-pkg

sudo chown $(whoami).$(whoami) -R ${MY_HOME}/output
cp -arvf ${MY_HOME}/*.deb ${MY_HOME}/output/
