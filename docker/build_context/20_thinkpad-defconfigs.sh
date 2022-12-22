#!/bin/sh -e
##
## check out thinkpad defconfigs and link into linux sources
##
SOURCES_DIR="${1}"
if [ ! -d "${SOURCES_DIR}" ]; then
    echo "FAIL: no linux sources available in '${SOURCES_DIR}'"
    exit 1
fi

export KDEFCONFIG_NAME="lothars_defconfig"
export KDEFCONFIG_BRANCH="master"

if [ -d "${CONFIGS_DIR}" ]; then
  if [ ! -d "${CONFIGS_DIR}/linux-defconfigs" ]; then
      cd "${CONFIGS_DIR}"
      git clone -j4 --depth=1 --branch ${KDEFCONFIG_BRANCH} https://github.com/Rubusch/linux-defconfigs.git
  fi
  cd "${SOURCES_DIR}/arch/x86/configs"
  ln -s "${CONFIGS_DIR}/linux-defconfigs/arch/x86/configs/${KDEFCONFIG_NAME}" .
fi
