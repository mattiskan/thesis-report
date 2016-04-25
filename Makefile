all: report.pdf

entr:
	ls *.bib *.tex | entr -c make all

# Spellcheck
#
# Let's you interactively spellcheck the diff in report.tex, and stages once done.
# This way, subsequent spell-checks only include new changes. Pretty neat.
#
# This could be made better by just not including anyhting but the patch content (i.e. not
# the patch headers or lines starting with a minus), but whatever, just be careful
# and look what you're spellchecking.
spell:
	git diff -U1 --no-color report.tex > .spellcheck.patch
	tail -n +5 .spellcheck.patch > .spellcheck.tex  # remove diff headers
	aspell --lang=en --mode=tex -p./spellcheck_whitelist check .spellcheck.tex

	head -n 4 .spellcheck.patch > .spellcheck_done.patch
	cat .spellcheck.tex >> .spellcheck_done.patch

	git apply --check --cached .spellcheck_done.patch  # make sure it works before we checkout
	git checkout report.tex
	git apply --ignore-whitespace .spellcheck_done.patch
	git add report.tex

report.pdf: report.tex report.bbl report.gls
	xelatex report.tex


report.bbl: references.bib
	xelatex report.tex
	bibtex report
	xelatex report.tex

report.gls:
	xelatex report.tex
	makeglossaries report

clean:
	git clean -fX
