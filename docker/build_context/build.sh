#!/bin/sh -e
export MY_USER="${USER}"
export MY_HOME="/home/${MY_USER}"
export WORKSPACE_DIR="${MY_HOME}/workspace"
export SOURCES_DIR="${WORKSPACE_DIR}/linux"
export CONFIGS_DIR="${MY_HOME}/configs"
export LINUX_BRANCH="rpi-6.3.y"

## prepare
00_devenv.sh "${WORKSPACE_DIR}" "${CONFIGS_DIR}"

## get sources
10_linux-devel-sources.sh "${SOURCES_DIR}"

## rpi toolchain
20_rpi-tools.sh

## development
90_devel-preparation.sh "${SOURCES_DIR}"

## build / clean
cd "${SOURCES_DIR}"
make clean
#make ${KDEFCONFIG_NAME}
#make -j16 deb-pkg

echo "READY."
echo
