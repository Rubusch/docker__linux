#!/bin/sh -e
## development tools setup

SOURCES_DIR="${1}"
if [ ! -d "${SOURCES_DIR}" ]; then
    echo "FAIL: no linux sources available in '${SOURCES_DIR}'"
    exit 1
fi
cd "${SOURCES_DIR}"

## source toolchain
source ${WORKSPACE_DIR}/source-me.sh

## prepare sources
make ${KDEFCONFIG_NAME}

## build
#make -j4 Image.gz modules dtbs

## build - make debian package with kernel and modules (will be in upper directory)
make -j4 bindeb-pkg

## generate TAGS
rm -f ./TAGS
make tags

## setup checkpatch / codespell
echo "#!/bin/sh" > "${SOURCES_DIR}/.git/hooks/post-commit"
echo "exec git show --format=email HEAD | ./scripts/checkpatch.pl --strict --codespell" >> "${SOURCES_DIR}/.git/hooks/post-commit"
chmod a+x "${SOURCES_DIR}/.git/hooks/post-commit"
