#!/bin/sh -e
## basic setup, fix/check permissions and ssh known_hosts
## setup build config
##
## call, optionally with additionally mounted folders:
## $0 <folder1> <folder2>...

MY_USER="$(whoami)"
MY_HOME="/home/${MY_USER}"
SSH_DIR="${MY_HOME}/.ssh"
SSH_KNOWN_HOSTS="${SSH_DIR}/known_hosts"
CONFIGS_DIR="${MY_HOME}/configs"

## permissions
for item in "${MY_HOME}/.gitconfig" "${SSH_DIR}" "${CONFIGS_DIR}" $*; do
    test -e "${item}" || continue
    if [ ! "${MY_USER}" = "$( stat -c %U "${item}" )" ]; then
        ## may take some time
        sudo chown "${MY_USER}":"${MY_USER}" -R "${item}"
    fi
done

## ssh known_hosts
touch "${SSH_KNOWN_HOSTS}"
for item in "github.com" "bitbucket.org"; do
    SSH_HOSTS="$( grep "${item}" -r "${SSH_KNOWN_HOSTS}" )" || true
    if [ -z "${SSH_HOSTS}" ]; then
        ssh-keyscan "${item}" >> "${SSH_KNOWN_HOSTS}"
    fi
done

## prepare machine config, in case source the file
if [ ! -e "${WORKSPACE_DIR}/machine.conf" ]; then
     cat<<EOF > "${WORKSPACE_DIR}/machine.conf"
## rpi4 (64)
## ref: https://www.raspberrypi.com/documentation/computers/linux_kernel.html
export LINUX_BRANCH="rpi-6.3.y"
export CROSS_COMPILE="aarch64-linux-gnu-"
export ARCH="arm64"
export KERNEL="kernel8"
export KDEFCONFIG_NAME="bcm2711_defconfig"
export KERNEL_URL="https://github.com/raspberrypi/linux"

## rpi3b (32)
#export LINUX_BRANCH="rpi-6.3.y"
#export CROSS_COMPILE="arm-linux-gnueabihf-"
#export ARCH="arm"
#export KERNEL="kernel7"
#export KDEFCONFIG_NAME="bcm2709_defconfig"

## linux kernel staging (patches) - gkh
#export LINUX_BRANCH=TODO
#export CROSS_COMPILE=TODO
#export ARCH=TODO
#export KERNEL=TODO
#export KDEFCONFIG_NAME=TODO
#export KERNEL_URL="git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git"

## linux kernel staging (patches) - thorvalds
#export LINUX_BRANCH=TODO
#export CROSS_COMPILE=TODO
#export ARCH=TODO
#export KERNEL=TODO
#export KDEFCONFIG_NAME=TODO
#export KERNEL_URL="git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"

## linux kernel next (testing) - kernel.org
#export LINUX_BRANCH=TODO
#export CROSS_COMPILE=TODO
#export ARCH=TODO
#export KERNEL=TODO
#export KDEFCONFIG_NAME=TODO
#export KERNEL_URL="git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git"
EOF
fi

source "${WORKSPACE_DIR}/machine.conf"
