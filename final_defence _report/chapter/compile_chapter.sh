#!/bin/bash
# Compile one chapter standalone for review, using its generated wrapper
# in chapter/build/_compile_<name>.tex. All LaTeX build junk
# (.aux/.log/.out/.toc/.lof/.lot) stays inside chapter/build/.
# Only the finished chapter PDF is copied back next to the chapter's .tex.
#
# Usage: bash compile_chapter.sh 1_introduction
#        bash compile_chapter.sh 3_methodology
set -e
cd "$(dirname "$0")"

if [ -z "$1" ]; then
  echo "Usage: bash compile_chapter.sh <chapter_dir_name>  (e.g. 1_introduction)"
  exit 1
fi

CHDIR="$1"
NAME=$(basename "$CHDIR" | sed -E 's/^[0-9]+_//')
TEXFILE=$(ls "$CHDIR"/chapter*.tex 2>/dev/null | head -n1)

if [ -z "$TEXFILE" ]; then
  echo "No chapter .tex found in $CHDIR"
  exit 1
fi

BASENAME=$(basename "$TEXFILE" .tex)
WRAPPER="build/_compile_${BASENAME}.tex"

if [ ! -f "$WRAPPER" ]; then
  echo "No wrapper found at $WRAPPER (expected one generated per the chapter-split workflow)"
  exit 1
fi

export TEXINPUTS=".:$(pwd)/$CHDIR:"
pdflatex -interaction=nonstopmode -halt-on-error -output-directory=build "$WRAPPER"
pdflatex -interaction=nonstopmode -halt-on-error -output-directory=build "$WRAPPER"

cp "build/$(basename "$WRAPPER" .tex).pdf" "$CHDIR/$BASENAME.pdf"

echo "Done. Updated $CHDIR/$BASENAME.pdf; build artifacts stayed in build/."
