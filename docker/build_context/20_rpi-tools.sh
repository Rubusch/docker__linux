#!/bin/sh -e
##
## checkout toolchain
##
TOOLS_DIR="${1}"

cd "${MY_HOME}"
if [ -d "${TOOLS_DIR}" ]; then
    cd "${TOOLS_DIR}"
    git fetch --all || exit 1
else
    mkdir -p "${TOOLS_DIR}"
    cd "${TOOLS_DIR}"
    git clone https://github.com/raspberrypi/tools .

    cd "${MY_HOME}"
    ln -sf "${TOOLS_DIR}" ~/tools

    echo 'export PATH=~/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin:${PATH}' > ${WORKSPACE_DIR}/source-me.sh
    echo 'export TOOLCHAIN=~/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/' >> ${WORKSPACE_DIR}/source-me.sh
    echo 'export CROSS_COMPILE=arm-linux-gnueabihf-' >> ${WORKSPACE_DIR}/source-me.sh
    echo 'export ARCH=arm' >> ${WORKSPACE_DIR}/source-me.sh
fi

if [ ! -d "${TOOLS_DIR}" ]; then
    echo "FAIL: no linux sources were cloned into '${SOURCES_DIR}'"
    exit 1
fi
