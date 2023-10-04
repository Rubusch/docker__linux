#!/bin/sh -e
export MY_USER="${USER}"
export MY_HOME="/home/${MY_USER}"
export WORKSPACE_DIR="${MY_HOME}/workspace"
export SOURCES_DIR="${WORKSPACE_DIR}/linux"
export CONFIGS_DIR="${MY_HOME}/configs"

## prepare
00_devenv.sh "${WORKSPACE_DIR}" "${CONFIGS_DIR}"

## prepare machine config, in case source the file
if [ ! -e "${WORKSPACE_DIR}/machine.conf" ]; then
     cat<<EOF > "${WORKSPACE_DIR}/machine.conf"
## rpi4 (64)
## ref: https://www.raspberrypi.com/documentation/computers/linux_kernel.html
export KERNEL_URL="https://github.com/raspberrypi/linux"
export LINUX_BRANCH="rpi-6.3.y"
export KDEFCONFIG_NAME="bcm2711_defconfig"
export CROSS_COMPILE="aarch64-linux-gnu-"
export ARCH="arm64"
export KERNEL="kernel8"
export BUILD_TARGETS="Image modules dtbs"

## rpi3b (32)
#export KERNEL_URL="https://github.com/raspberrypi/linux"
#export LINUX_BRANCH="rpi-6.3.y"
#export KDEFCONFIG_NAME="bcm2709_defconfig"
#export CROSS_COMPILE="arm-linux-gnueabihf-"
#export ARCH="arm"
#export KERNEL="kernel7"
#export BUILD_TARGETS="zImage modules dtbs"

## linux kernel staging (patches) - gkh
#export KERNEL_URL="git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git"
#export LINUX_BRANCH=TODO
#export KDEFCONFIG_NAME=TODO
#export CROSS_COMPILE=TODO
#export ARCH=TODO
#export KERNEL=TODO
#export BUILD_TARGETS="bindeb-pkg modules dtbs"

## linux kernel staging (patches) - thorvalds
#export KERNEL_URL="git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"
#export LINUX_BRANCH=TODO
#export KDEFCONFIG_NAME=TODO
#export CROSS_COMPILE=TODO
#export ARCH=TODO
#export KERNEL=TODO
#export BUILD_TARGETS="bindeb-pkg modules dtbs"

## linux kernel next (testing) - kernel.org
#export KERNEL_URL="git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git"
#export LINUX_BRANCH=TODO
#export KDEFCONFIG_NAME=TODO
#export CROSS_COMPILE=TODO
#export ARCH=TODO
#export KERNEL=TODO
#export BUILD_TARGETS="bindeb-pkg modules dtbs"
EOF
fi
source "${WORKSPACE_DIR}/machine.conf"

## get sources
10_fetch-sources.sh "${SOURCES_DIR}"

## rpi toolchain
20_prepare-source-me.sh "${WORKSPACE_DIR}/tools"

## prepare sources, configure DT, run build and crate TAGS
30_build-sources.sh "${SOURCES_DIR}"

echo "READY."
echo
