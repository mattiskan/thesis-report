all: report.pdf

entr:
	ls *.bib *.tex | entr -c make all

spell:
	git diff --no-color report.tex > .spellcheck.patch
	tail -n +5 .spellcheck.patch > .spellcheck.tex  # remove diff headers
	aspell --lang=en --mode=tex -p./spellcheck_whitelist check .spellcheck.tex

	head -n 4 .spellcheck.patch > .spellcheck_done.patch
	cat .spellcheck.tex >> .spellcheck_done.patch

	git checkout report.tex
	git apply --ignore-whitespace .spellcheck_done.patch

report.pdf: report.tex report.bbl
	xelatex report.tex

report.bbl: references.bib
	xelatex report.tex
	bibtex report
	xelatex report.tex

clean:
	git clean -fX
