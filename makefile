PICTURES=$(wildcard *.svg)
PIC_PDF=$(PICTURES:.svg=.pdf)
PIC_TEX=$(PIC_PDF:.pdf=.pdf_tex)
TARGET=workbook.pdf
.SUFFIXES: .svg .pdf

all: $(TARGET) 
	evince $(TARGET)

$(TARGET): .patched
	latexmk

#patch: .patch.done 
.patched: $(PIC_TEX) 
	$(foreach f, $(PIC_TEX), python ./patch-export-latex.py $(f);)
	@touch .patched
#patch: $(PIC_TEX) 
#	@echo "patch"
#	$(foreach f, $^, python ./patch-export-latex.py $(f);)

$(PIC_TEX): $(PIC_PDF)

.svg.pdf:
	inkscape -D -z --file=$< --export-pdf=$@ --export-latex

clean:
	rm $(PIC_TEX)
	rm $(PIC_PDF)
	rm .patched
	latexmk -c
