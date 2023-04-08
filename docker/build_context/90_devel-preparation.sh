#!/bin/sh -e
##
## development tools setup
## ref: https://www.raspberrypi.com/documentation/computers/linux_kernel.html
SOURCES_DIR="${1}"
if [ ! -d "${SOURCES_DIR}" ]; then
    echo "FAIL: no linux sources available in '${SOURCES_DIR}'"
    exit 1
fi
cd "${SOURCES_DIR}"

## source toolchain
source ${WORKSPACE_DIR}/source-me.sh

## prepare sources
make bcm2711_defconfig

## build
make -j4 Image.gz modules dtbs

## make debian package with kernel and modules (will be in upper directory)
make bindeb-pkg

## generate TAGS
rm -f ./TAGS
#find . -regex ".*\.\(h\|c\)$" -exec etags -a {} \;
make tags

## setup checkpatch / codespell
echo "#!/bin/sh" > "${SOURCES_DIR}/.git/hooks/post-commit"
echo "exec git show --format=email HEAD | ./scripts/checkpatch.pl --strict --codespell" >> "${SOURCES_DIR}/.git/hooks/post-commit"
chmod a+x "${SOURCES_DIR}/.git/hooks/post-commit"


## manual installation then follows (on the target)
##
## -> Install compiled modules: copy over to /lib/modules...
## -> Copy the kernel, modules, and other files to the boot filesystem,
## locally this would be the following
#cp arch/arm/boot/dts/*.dtb /boot/
#cp arch/arm/boot/dts/overlays/*.dtb* /boot/overlays/
#cp arch/arm/boot/dts/overlays/README /boot/overlays/
#cp arch/arm/boot/zImage /boot/kernel-stephen.img
#
## -> Configure the PI to boot using the new kernel by modifying and adding the
## below line to "/boot/config.txt"
#kernel=kernel-demo.img
