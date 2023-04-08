#!/bin/sh -e
##
## toolchain setup
##
if [ ! -e "${WORKSPACE_DIR}/source-me.sh" ]; then
    echo 'export CROSS_COMPILE=aarch64-linux-gnu-' > ${WORKSPACE_DIR}/source-me.sh
    echo 'export ARCH=arm64' >> ${WORKSPACE_DIR}/source-me.sh
	echo 'export KERNEL=kernel8' >> ${WORKSPACE_DIR}/source-me.sh
fi
