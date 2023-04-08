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
make tags

## setup checkpatch / codespell
echo "#!/bin/sh" > "${SOURCES_DIR}/.git/hooks/post-commit"
echo "exec git show --format=email HEAD | ./scripts/checkpatch.pl --strict --codespell" >> "${SOURCES_DIR}/.git/hooks/post-commit"
chmod a+x "${SOURCES_DIR}/.git/hooks/post-commit"


## manual installation then follows (on the target)
##
#make -j4 Image.gz modules dtbs
#sudo make modules_install
#sudo cp arch/arm64/boot/dts/broadcom/*.dtb /boot/
#sudo cp arch/arm64/boot/dts/overlays/*.dtb* /boot/overlays/
#sudo cp arch/arm64/boot/dts/overlays/README /boot/overlays/
#sudo cp arch/arm64/boot/Image.gz /boot/$KERNEL.img
#
## NB: configure to boot the specific kernel in "/boot/config.txt", i.e. set a name in the kernel config
#kernel=kernel-demo.img
