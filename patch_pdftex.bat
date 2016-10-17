for %%p in (*.svg) do (
	inkscape -D -z --file=./%%p --export-pdf=./%%~np.pdf --export-latex
	)
for %%f in (*.pdf_tex) do (
	python patch-export-latex.py ./%%f
	)