#!/bin/bash

set -e

die() {
  echo "$1" >&2
  exit 1
}

which pandoc > /dev/null 2>&1 || die "pandoc needs to be installed"

if [ $# -ne 2 ]; then
  echo "Usage: $0 <LaTeX source directory> <RST destination directory>"
  exit 2
fi

SRC_DIR="$1"
DST_DIR="$2"

[ -d $SRC_DIR ] || die "$SRC_DIR doesn't exist"
[ -d $DST_DIR ] || die "$DST_DIR doesn't exist"

CHAPTERS="cpt-benchmarks.tex cpt-details.tex cpt-quickstart.tex cpt-repo.tex \
          cpt-configure.tex cpt-overview.tex cpt-replica.tex cpt-squid.tex"

for c in $CHAPTERS; do
  [ -e ${SRC_DIR}/$c ] || die "didn't find $c"
done

for c in $CHAPTERS; do
  dst=$(basename -s .tex $c)
  echo -n "converting ${c} to ${dst}... "
  pandoc --from latex \
         --to   rst   \
         ${SRC_DIR}/$c > ${DST_DIR}/$dst || die "fail"
  echo "done"
done
