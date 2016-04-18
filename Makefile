all: report.pdf

entr:
	ls *.bib *.tex | entr -c make all

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

report.pdf: report.tex report.bbl
	xelatex report.tex

report.bbl: references.bib
	xelatex report.tex
	bibtex report
	xelatex report.tex

clean:
	git clean -fX
