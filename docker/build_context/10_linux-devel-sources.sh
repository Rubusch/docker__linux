#!/bin/sh -e
## check out linux devel sources

SOURCES_DIR="${1}"

cd "${MY_HOME}"
if [ -d "${SOURCES_DIR}" ]; then
    cd "${SOURCES_DIR}"
    git fetch --all || exit 1
else
    cd "${WORKSPACE_DIR}"
    git clone -j "$(nproc)" --depth=1 --branch "$LINUX_BRANCH" $KERNEL_URL "linux_${CROSS_COMPILE}${LINUX_BRANCH}"
    ln -s "linux_${CROSS_COMPILE}${LINUX_BRANCH}" "$SOURCES_DIR"
fi

if [ ! -d "${SOURCES_DIR}" ]; then
    echo "FAIL: no linux sources were cloned into '${SOURCES_DIR}'"
    exit 1
fi
