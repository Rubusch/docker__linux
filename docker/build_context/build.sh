#!/bin/sh -e
export MY_USER="${USER}"
export MY_HOME="/home/${MY_USER}"
export WORKSPACE_DIR="${MY_HOME}/workspace"
export SOURCES_DIR="${WORKSPACE_DIR}/linux"
export CONFIGS_DIR="${MY_HOME}/configs"
export LINUX_BRANCH="rpi-6.3.y"
export CROSS_COMPILE="aarch64-linux-gnu-"
export ARCH="arm64"
export KERNEL="kernel8"
export KDEFCONFIG_NAME="bcm2711_defconfig"

## prepare
00_devenv.sh "${WORKSPACE_DIR}" "${CONFIGS_DIR}"

## get sources
10_linux-devel-sources.sh "${SOURCES_DIR}"

## rpi toolchain
20_rpi-tools.sh "${WORKSPACE_DIR}/tools"

## prepare sources, configure DT, run build and crate TAGS
90_devel-preparation.sh "${SOURCES_DIR}"

echo "READY."
echo
