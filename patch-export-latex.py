# -*- coding: utf-8 -*-
"""
Patch .pdf_tex files through Inkscape's --export-latex option.

Usage:
$ python patch-export-latex.py <.pdf_tex filepath>

Examples:
$ inkscape -D -z --file=foobar.svg --export-pdf=figures/foobar.pdf --export-latex
$ python patch-export-latex.py figures/foobar.pdf_tex

Copyright (C) 2016 Donghyeon Lee
"""

import sys
import os.path
import re

def patch(pdftex):
    with open(pdftex, 'r') as f:
        content = f.read()
    content = re.sub('.*\\\\put\(0\,0\)\{\\\\includegraphics\[width=\\\\unitlength\,page=(?!1).*', '', content)
    content = re.sub('.*\\\\put\(0\,0\)\{\\\\includegraphics\[width=\\\\unitlength\,page=\d{2}.*', '', content)
    pdfname = os.path.basename(pdftex).replace('pdf_tex', 'pdf')
    pdf = pdftex.replace('pdf_tex', 'pdf')
    content = content.replace(pdfname, pdf)
    with open(pdftex, 'w') as f:
        f.write(content)
    print 'fin'

if __name__ == '__main__':
    patch(sys.argv[1])
