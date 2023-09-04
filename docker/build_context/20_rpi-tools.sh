#!/bin/sh -e
## toolchain setup

if [ ! -e "${WORKSPACE_DIR}/source-me.sh" ]; then
	echo "export CROSS_COMPILE=${CROSS_COMPILE}" > ${WORKSPACE_DIR}/source-me.sh
	echo "export ARCH=${ARCH}" >> ${WORKSPACE_DIR}/source-me.sh
	echo "export KERNEL=${KERNEL}" >> ${WORKSPACE_DIR}/source-me.sh
	echo "export KDEFCONFIG_NAME=${KDEFCONFIG_NAME}" >> ${WORKSPACE_DIR}/source-me.sh
	echo "export KERNELDIR=\"/home/user/workspace/linux\"" >> ${WORKSPACE_DIR}/source-me.sh
fi
