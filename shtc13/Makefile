#
# This file may be distributed and/or modified under the terms of 
# the Do What The Fuck You Want To Public License, Version 2
#

SOURCE=shtc2013
LATEX=pdflatex

all: shtc

shtc:
	$(LATEX) -jobname -shell-escape $(SOURCE).tex

clean:
	rm -f *.aux *.out *.log 
	rm -f *.snm *.toc *.nav

mrproper: clean
	rm -f $(SOURCE).pdf
