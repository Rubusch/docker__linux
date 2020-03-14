#!/bin/bash -e
HOME="/home/$(whoami)"
BRANCH="master"
SOURCES="${HOME}/linux"
CONFIGS="${HOME}/configs"
SHARES=( ${SOURCES} ${CONFIGS} )

## fix permissions
for item in ${SHARES[*]}; do
    test -e ${item} && sudo chown $(whoami).$(whoami) -R ${item}
done

cd ${HOME}

if [[ -d "${SOURCES}/.git" ]]; then
  cd linux
  git fetch --all
else
  #git clone -j4 --depth=1 --branch $BRANCH https://github.com/Rubusch/linux.git linux
  git clone -j4 --depth=1 --branch staging-testing git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git linux
fi

cd ${SOURCES}
make clean

echo "READY."
echo
