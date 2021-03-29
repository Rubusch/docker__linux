
#!/bin/bash -e
HOME="/home/$(whoami)"
BRANCH="master"
SOURCES_DIR="${HOME}/linux"
CONFIGS_DIR="${HOME}/configs"
SECRETS_DIR="${HOME}/secrets"
SHARES=( ${SOURCES_DIR} ${CONFIGS_DIR} ${SECRETS_DIR} )

## fix permissions
for item in ${SHARES[*]}; do
    test -e ${item} && sudo chown $(whoami).$(whoami) -R ${item}
done

if [[ ! -f ${SECRETS_DIR}/.gitconfig ]]; then
    cp ${CONFIGS_DIR}/.gitconfig ${SECRETS_DIR}/.gitconfig
    echo "!!! FIRST TIME INSTALLATION !!!"
    echo "!!!"
    echo "!!! PLEASE FILL SECRET INFORMATION (NOT GIT TRACKED) IN"
    echo "!!! '${SECRETS_DIR}/.gitconfig'"
    echo "!!! THEN LOGIN AGAIN"
    echo "!!!"
    exit 0
fi

cd ${HOME}

## get sources
if [[ -d "${SOURCES_DIR}/.git" ]]; then
  cd ${SOURCES_DIR}
  git fetch --all
else
  git clone -j4 --branch staging-testing git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git linux
  #git clone --depth 1 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
  #git clone -j4 git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
fi

## generate TAGS
cd ${SOURCES_DIR}
rm -f ./TAGS
find . -regex ".*\.\(h\|c\)$" -exec etags -a {} \;

## setup checkpatch / codespell
echo "#!/bin/sh" > ${SOURCES_DIR}/.git/hooks/post-commit
echo "exec git show --format=email HEAD | ./scripts/checkpatch.pl --strict --codespell" >> ${SOURCES_DIR}/.git/hooks/post-commit
chmod a+x ${SOURCES_DIR}/.git/hooks/post-commit

cd ${SOURCES_DIR}
make clean

echo "READY."
echo
