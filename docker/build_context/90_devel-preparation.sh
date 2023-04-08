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
make bcm2709_defconfig

## build kernel
make -j4 zImage modules dtbs

## make debian package with kernel and modules (will be in upper directory)
make bindeb-pkg

## generate TAGS
rm -f ./TAGS
make tags

## setup checkpatch / codespell
echo "#!/bin/sh" > "${SOURCES_DIR}/.git/hooks/post-commit"
echo "exec git show --format=email HEAD | ./scripts/checkpatch.pl --strict --codespell" >> "${SOURCES_DIR}/.git/hooks/post-commit"
chmod a+x "${SOURCES_DIR}/.git/hooks/post-commit"


## manual installation then follows (on the target)
##
#make -j4 zImage modules dtbs
#sudo make modules_install
#sudo cp arch/arm/boot/dts/*.dtb /boot/
#sudo cp arch/arm/boot/dts/overlays/*.dtb* /boot/overlays/
#sudo cp arch/arm/boot/dts/overlays/README /boot/overlays/
#sudo cp arch/arm/boot/zImage /boot/$KERNEL.img
