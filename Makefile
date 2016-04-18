all: report.pdf

entr:
	ls *.bib *.tex | entr -c make all

spell:
	aspell --lang=en --mode=tex check *.tex

report.pdf: report.tex report.bbl
	xelatex report.tex

report.bbl: references.bib
	xelatex report.tex
	bibtex report
	xelatex report.tex

clean:
	git clean -fX
