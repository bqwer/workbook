PICTURES=$(wildcard *.svg)
PIC_PDF=$(PICTURES:.svg=.pdf)
PIC_TEX=$(PIC_PDF:.pdf=.pdf_tex)
TARGET=workbook.pdf
SOURCES=$(wildcard *.tex)
.SUFFIXES: .svg .pdf
.PHONY: all clean

all: $(TARGET) 
	mupdf $(TARGET)

$(TARGET): .patched $(SOURCES)
	latexmk

.patched: $(PIC_TEX)
	$(foreach f, $?, python ./patch-export-latex.py $(f);)
	@touch .patched

$(PIC_TEX): $(PIC_PDF);

.svg.pdf:
	inkscape -D -z --file=$< --export-pdf=$@ --export-latex

clean:
	rm -f $(PIC_TEX)
	rm -f $(PIC_PDF)
	rm -f .patched
	latexmk -c
