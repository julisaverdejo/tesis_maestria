
.PHONY: compile compile_full clean view

all: compile 

compile:
	pdflatex main.tex >> logs.txt
	
compile_full:
	latex main.tex > logs.txt
	bibtex main >> logs.txt
	latex main.tex >> logs.txt
	pdflatex main.tex >> logs.txt

view:
	sumatrapdf main.pdf

clean:
	rm -rf *.aux *.toc *.lol *.lot *.lof *.ist *.glo *.glg *.gls *.log *.bbl *.out *.dvi *.blg
