#!/bin/bash

set -e

SCRIPT_LOCATION=$(cd "$(dirname "$0")"; pwd)

die() {
  echo "$1" >&2
  exit 1
}

has() {
  which $1 > /dev/null 2>&1
}

has pandoc          || die "pandoc needs to be installed"
has pandoc-citeproc || die "pandoc-citeproc needs to be installed"

if [ $# -ne 2 ]; then
  echo "Usage: $0 <LaTeX source directory> <RST destination directory>"
  exit 2
fi

SRC_DIR="$1"
DST_DIR="$2"

[ -d $SRC_DIR ] || die "$SRC_DIR doesn't exist"
[ -d $DST_DIR ] || die "$DST_DIR doesn't exist"

CHAPTERS="cpt-overview.tex cpt-quickstart.tex cpt-configure.tex cpt-squid.tex \
          cpt-repo.tex cpt-replica.tex cpt-details.tex"

INDEXDOC="cvmfstech.tex"
BIBLIOGRAHPY="references.bib"
CSL="${SCRIPT_LOCATION}/acm-sig-proceedings.csl"

for c in $CHAPTERS; do
  [ -e ${SRC_DIR}/$c ] || die "didn't find $c"
done

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo -n "setting up environment... "
cleanup() {
  rm -f $PREAMBLE
}

trap cleanup EXIT HUP INT TERM
PREAMBLE=$(mktemp)
echo "done"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo -n "preparing preamble... "
grep -e 'providecommand' ${SRC_DIR}/${INDEXDOC} >  $PREAMBLE
echo "\renewcommand{\product}[1]{#1}"           >> $PREAMBLE
echo "done"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

for c in $CHAPTERS; do
  dst="$(basename -s .tex $c).rst"
  echo -n "converting ${c} to ${dst}... "
  pandoc --from latex                              \
         --to   rst                                \
         --bibliography=${SRC_DIR}/${BIBLIOGRAHPY} \
         --csl=$CSL                                \
         $PREAMBLE                                 \
         ${SRC_DIR}/$c > ${DST_DIR}/$dst || die "fail"
  echo "done"
done
