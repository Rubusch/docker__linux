#!/bin/sh -e
##
## toolchain setup
##
cd "${MY_HOME}"
if [ ! -e "${WORKSPACE_DIR}/source-me.sh" ]; then
    echo 'export CROSS_COMPILE=arm-linux-gnu-' > ${WORKSPACE_DIR}/source-me.sh
    echo 'export ARCH=arm' >> ${WORKSPACE_DIR}/source-me.sh
    echo 'export KERNEL=kernel7' >> ${WORKSPACE_DIR}/source-me.sh
fi
