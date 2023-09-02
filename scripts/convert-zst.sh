#!/bin/sh -e
##
## repack .deb files to use older .tar.gz instead of .tar.zst for targets where
## this is an issue

die()
{
	echo "ABORTING: $@"
	exit 1
}

usage()
{
	cat <<EOF
usage:
	$ $0 [list of .deb files]

	also possible
	$ $0 ./*.deb
EOF
}

TMPDIR=".tmp-deb"
test $# -eq 0 && usage && die "${USAGE}" 
test -e $TMPDIR && die "'$TMPDIR' already exists, please remove it before"
test -z "$(which ar)" && die "'ar' is not installed"
test -z "$(which zstd)" && die "'zstd' is not installed"
test -z "$(which xz)" && die "'xz' is not installed"
for item in $@; do
	item=$(readlink -f $item)
	echo "convert ${item}..."
	mkdir -p "$TMPDIR"
	cd "$TMPDIR"
	ar x $item
	ls -1 *.zst || die "no .zst files in the package"
	zstd -d *.zst
	rm *.zst
	xz *.tar
	ar r "${item}.repacked" debian-binary control.tar.xz data.tar.xz
	cd ..
	mv "${item}.repacked" "${item}"
	rm -rf "$TMPDIR"
	echo "ok"
done
echo "READY."
