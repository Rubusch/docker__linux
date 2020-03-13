#!/bin/sh -e
MY_USER="$(whoami)"
MY_HOME="/home/${MY_USER}"
SSH_DIR="${MY_HOME}/.ssh"
SSH_KNOWN_HOSTS="${SSH_DIR}/known_hosts"
SOURCES_DIR="${MY_HOME}/linux"
CONFIGS_DIR="${MY_HOME}/configs"
LINUX_BRANCH="staging-testing"

## permissions
for item in "${SOURCES_DIR}" "${CONFIGS_DIR}" "${SSH_DIR}" "${MY_HOME}/.gitconfig"; do
    if [ ! "${MY_USER}" = "$( stat -c %U "${item}" )" ]; then
        ## may take some time
        sudo chown "${MY_USER}:${MY_USER}" -R "${item}"
    fi
done

## ssh known_hosts
touch "${SSH_KNOWN_HOSTS}"
for item in "github.com" "bitbucket.org"; do
    if [ "" = "$( grep "${item}" -r "${SSH_KNOWN_HOSTS}" )" ]; then
        ssh-keyscan "${item}" >> "${SSH_KNOWN_HOSTS}"
    fi
done

## get sources
cd "${MY_HOME}"
if [ -d "${SOURCES_DIR}/.git" ]; then
    cd "${SOURCES_DIR}"
    git fetch --all
else
    git clone -j "$(nproc)" --branch "${LINUX_BRANCH}" git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git linux
    #git clone -j "$(nproc)" --depth 1 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
    #git clone -j "$(nproc)" git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
fi

## generate TAGS
cd "${SOURCES_DIR}"
rm -f ./TAGS
find . -regex ".*\.\(h\|c\)$" -exec etags -a {} \;

## setup checkpatch / codespell
echo "#!/bin/sh" > "${SOURCES_DIR}/.git/hooks/post-commit"
echo "exec git show --format=email HEAD | ./scripts/checkpatch.pl --strict --codespell" >> "${SOURCES_DIR}/.git/hooks/post-commit"
chmod a+x "${SOURCES_DIR}/.git/hooks/post-commit"

cd "${SOURCES_DIR}"
make clean

echo "READY."
echo
