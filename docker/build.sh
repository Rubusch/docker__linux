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

## get sources
if [[ -d "${SOURCES}/.git" ]]; then
  cd ${SOURCES}
  git fetch --all
else
  #git clone -j4 --branch $BRANCH https://github.com/Rubusch/linux.git linux
  git clone -j4 --branch staging-testing git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git linux
  #git clone --depth 1 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
  #git clone -j4 git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
fi

## generate TAGS
cd ${SOURCES}
rm -f ./TAGS
find . -regex ".*\.\(h\|c\)$" -exec etags -a {} \;

## setup checkpatch / codespell
echo "#!/bin/sh" > ${SOURCES}/.git/hooks/post-commit
echo "exec git show --format=email HEAD | ./scripts/checkpatch.pl --strict --codespell" >> ${SOURCES}/.git/hooks/post-commit
chmod a+x ${SOURCES}/.git/hooks/post-commit

cd ${SOURCES}
make clean

echo "READY."
echo
