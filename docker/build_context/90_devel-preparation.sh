#!/bin/sh -e
##
## development tools setup
##
SOURCES_DIR="${1}"
if [ ! -d "${SOURCES_DIR}" ]; then
    echo "FAIL: no linux sources available in '${SOURCES_DIR}'"
    exit 1
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
