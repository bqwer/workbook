PICTURES=$(wildcard *.svg)
PIC_PDF=$(PICTURES:.svg=.pdf)
PIC_TEX=$(PIC_PDF:.pdf=.pdf_tex)
.SUFFIXES: .svg .pdf

all: patch 
	latexmk
	evince workbook.pdf

patch: .patch.done 
.patch.done: $(PIC_TEX) 
	$(foreach f, $(PIC_TEX), python ./patch-export-latex.py $(f);)
	@touch .patch.done

$(PIC_TEX): $(PIC_PDF)

.svg.pdf:
	inkscape -D -z --file=$< --export-pdf=$@ --export-latex

clean:
	rm $(PIC_TEX)
	rm $(PIC_PDF)
	rm .patch.done
	latexmk -c
