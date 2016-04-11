all: report.pdf

report.pdf: report.tex report.bbl
	xelatex report.tex

report.bbl: references.bib
	xelatex report.tex
	bibtex report
	xelatex report.tex

clean:
	git clean -fX
