#!/bin/bash -e
SOURCES="/home/$(whoami)/linux"

SHARES=( /mnt )
for item in ${SHARES[*]}; do
    test -e ${item} && sudo chown $(whoami).$(whoami) -R ${item}
done

cd ${SOURCES}
make clean
make-kpkg -j16 kernel-image modules-image kernel-headers --initrd

cp -arvf /home/$(whoami)/*.deb /mnt
