#!/bin/bash

SCRIPT_LOCATION=$(cd "$(dirname "$0")"; pwd)

die() {
  echo "$1" >&2
  exit 1
}

has() {
  which $1 > /dev/null 2>&1
}

has pdflatex || die "pdflatex needs to be installed"
has convert  || die "convert needs to be installed (imagemagick)"

if [ $# -ne 2 ]; then
  echo "Usage: $0 <LaTeX source file> <PNG destination directory>"
  exit 2
fi

IMG="$(cd "$(dirname $1)"; pwd)/$(basename $1)"
DST_DIR="$(cd "$2"; pwd)"

echo -n "setting up environment... "
cleanup() {
  cd /
  rm -fR $LATEX_ENV
}

trap cleanup EXIT HUP INT TERM
LATEX_ENV=$(mktemp -d)
cd $LATEX_ENV

DOC_ROOT=$(dirname $(dirname $IMG))
cp -R ${DOC_ROOT}/figures figures
cp -R ${DOC_ROOT}/packages.tex \
      ${DOC_ROOT}/gnuplot*     \
      .
echo "done"

echo -n "Building document... "
LATEX_IMG="img.tex"
cat > $LATEX_IMG << EOF
\documentclass{standalone}
\include{packages}

\begin{document}
EOF

cat $IMG >> $LATEX_IMG

cat >> $LATEX_IMG << EOF
\end{document}
EOF
echo "done"

DOC_BASENAME=$(basename -s .tex $LATEX_IMG)
pdflatex -interaction=batchmode $LATEX_IMG || cat ${DOC_BASENAME}.log

convert -density 300        \
        -quality 100        \
        -resize  850x       \
        ${DOC_BASENAME}.pdf \
        ${DOC_BASENAME}.png
OUTPUT_IMG=` (for f in *.png; do echo $f; done) | sort | tail -n1 `
cp $OUTPUT_IMG ${DST_DIR}/$(basename -s .tex $IMG).png
