#!/bin/sh -e
##
## check out linux devel sources
##
SOURCES_DIR="${1}"

cd "${MY_HOME}"
if [ -d "${SOURCES_DIR}" ]; then
    cd "${SOURCES_DIR}"
    git fetch --all || exit 1
else
    cd "${WORKSPACE_DIR}"
    git clone -j "$(nproc)" --branch "${LINUX_BRANCH}" git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git "$( basename "${SOURCES_DIR}" )"
    #git clone -j "$(nproc)" --depth 1 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
    #git clone -j "$(nproc)" git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
fi

if [ ! -d "${SOURCES_DIR}" ]; then
    echo "FAIL: no linux sources were cloned into '${SOURCES_DIR}'"
    exit 1
fi
