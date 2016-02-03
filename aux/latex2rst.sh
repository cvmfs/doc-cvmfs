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
  echo "Usage: $0 <LaTeX source file> <RST destination directory>"
  exit 2
fi

SRC_FILE="$1"
DST_DIR="$2"
SRC_DIR=$(dirname $SRC_FILE)

[ -e $SRC_FILE ] || die "$SRC_FILE doesn't exist"
[ -d $DST_DIR  ] || die "$DST_DIR doesn't exist"

INDEXDOC="cvmfstech.tex"
BIBLIOGRAHPY="references.bib"
CSL="${SCRIPT_LOCATION}/acm-sig-proceedings.csl"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo -n "setting up environment... "
cleanup() {
  rm -f $PREAMBLE
  rm -f $FILTERED_SRC
}

trap cleanup EXIT HUP INT TERM
PREAMBLE=$(mktemp)
FILTERED_SRC=$(mktemp)
echo "done"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo -n "preparing preamble... "
grep -e 'providecommand' ${SRC_DIR}/${INDEXDOC} >  $PREAMBLE
echo "\renewcommand{\product}[1]{#1}"           >> $PREAMBLE
echo "\renewcommand{\indexed}[1]{#1}"           >> $PREAMBLE
echo "done"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

dst="$(basename -s .tex $SRC_FILE).rst"
echo -n "converting ${SRC_FILE} to ${dst}... "
cat ${SRC_FILE} | sed -e 's/\\SI{\([0-9]*\)}{\\bit}/\1 bit/g' > $FILTERED_SRC

pandoc --from latex                              \
       --to   rst                                \
       --bibliography=${SRC_DIR}/${BIBLIOGRAHPY} \
       --csl=$CSL                                \
       $PREAMBLE                                 \
       ${FILTERED_SRC} > ${DST_DIR}/$dst || die "fail"
echo "done"
