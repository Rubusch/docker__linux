#!/bin/sh -e
#!/bin/sh -e
MY_USER="${USER}"
MY_HOME="/home/${MY_USER}"
WORKSPACE_DIR="${MY_HOME}/workspace"
SOURCES_DIR="${WORKSPACE_DIR}/linux"
CONFIGS_DIR="${MY_HOME}/configs"
LINUX_BRANCH="staging-testing"

## prepare
00_defenv.sh "${WORKSPACE_DIR}" "${CONFIGS_DIR}"

## get sources
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

## generate TAGS
test -d "${SOURCES_DIR}" || exit 1
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
