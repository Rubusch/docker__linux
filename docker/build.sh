#!/bin/bash -e
export KVERSION="v5.4"

export KDEFCONFIG_NAME="lothars_defconfig"
export KDEFCONFIG_BRANCH="lothar/${KVERSION}-thinkpad-x1"

export MY_HOME="/home/$(whoami)"
export MY_LINUX="${MY_HOME}/linux"
export MY_OUTPUT="${MY_HOME}/output"
export MY_CONFIGS="${MY_HOME}/configs"

## if linux-defconfigs is not there, clone it (ro), if already checked out, skip this step
if [ -d "${MY_CONFIGS}" ]; then
  if [ ! -d "${MY_CONFIGS}/linux-defconfigs" ]; then
      cd "${MY_CONFIGS}"
      git clone -j4 --depth=1 --branch ${KDEFCONFIG_BRANCH} https://github.com/Rubusch/linux-defconfigs.git
  fi

  cd "${MY_LINUX}/arch/x86/configs"
  ln -s "${MY_CONFIGS}/linux-defconfigs/arch/x86/configs/${KDEFCONFIG_NAME}" .
fi

cd "${MY_LINUX}"
make clean
make ${KDEFCONFIG_NAME}
make -j16 deb-pkg


sudo chown $(whoami).$(whoami) -R ${MY_OUTPUT}
cp -arvf ${MY_HOME}/*.deb ${MY_OUTPUT}/
