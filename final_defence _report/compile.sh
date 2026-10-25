#!/bin/bash
# Compile final_defence_report.tex, keeping all LaTeX build junk
# (.aux/.log/.out/.toc/.lof/.lot/.bbl/.blg) inside build/ instead of
# littering this folder. Only final_defence_report.pdf is copied back here.
set -e
cd "$(dirname "$0")"

SRC=final_defence_report
OUT=build

mkdir -p "$OUT"

pdflatex -interaction=nonstopmode -halt-on-error -output-directory="$OUT" "$SRC.tex"
bibtex "$OUT/$SRC"
pdflatex -interaction=nonstopmode -halt-on-error -output-directory="$OUT" "$SRC.tex"
pdflatex -interaction=nonstopmode -halt-on-error -output-directory="$OUT" "$SRC.tex"

cp "$OUT/$SRC.pdf" "./$SRC.pdf"

echo "Done. Updated $SRC.pdf in report root; build artifacts stayed in $OUT/."
