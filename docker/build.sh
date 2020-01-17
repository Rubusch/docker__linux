#!/bin/bash -e
SOURCES="/home/$(whoami)/linux"

SHARES=( /mnt )
for item in ${SHARES[*]}; do
    test -e ${item} && sudo chown $(whoami).$(whoami) -R ${item}
done

cd ${SOURCES}
make clean

## build kernel
#make-kpkg -j16 kernel-image modules-image kernel-headers --initrd
#cp -arvf /home/$(whoami)/*.deb /mnt

## build documentation
#make pdfdocs
#find ${SOURCES} -type f -name \*.pdf -exec cp -arf {} /mnt \;

## individual docs ( targets from https://www.kernel.org/doc/makehelp.txt )
## FAILING: driver-api RCU
for doc in iio hwmon vm openrisc sh PCI power leds livepatch mips arm64 powerpc accounting target virt timers x86 networking input mic cdrom infiniband media core-api w1 pcmcia netlabel riscv kbuild userspace-api watchdog s390 filesystems fb dev-tools kernel-hacking arm translations scheduler firmware-guide isdn admin-guide doc-guide block locking spi usb maintainer sound process sparc bpf security xtensa misc-devices fault-injection m68k parisc ia64 i2c gpu fpga trace hid ide crypto; do
    echo
    echo "*** ${doc} *******************************************************************************"
    echo
    make SPHINXDIRS="${doc}" pdfdocs
    find ${SOURCES} -type f -name \*.pdf -exec mv {} /mnt \;
done
