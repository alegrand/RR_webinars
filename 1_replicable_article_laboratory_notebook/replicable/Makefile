ARCHIVE=replicable
# ARCHIVE_FILES=$(shell git ls-tree -r master --name-only | grep -v -e 'article.pdf')
ARCHIVE_FILES=article.org biblio.bib Makefile
all: article.pdf

%.tex: %.org
	emacs -q -batch --eval "(setq enable-local-eval t)" --eval "(setq enable-local-variables t)" $^  --funcall org-latex-export-to-latex

%.pdf: %.tex
	pdflatex $^
	bibtex `basename $^ .tex`
	pdflatex $^
	pdflatex $^

%.html: %.org
	emacs -q -batch --eval "(setq enable-local-eval t)" --eval "(setq enable-local-variables t)" $^  --funcall org-html-export-to-html

$(ARCHIVE).tgz: $(ARCHIVE_FILES)
	tar --xform "s|^|$(ARCHIVE)/|" -zcf $@ $^

clean:
	rm -f article.aux article.bbl article.blg article.log article.out *~

distclean: clean
	rm -f article.html article.tex article.pdf figure.pdf data.csv measurements.txt IEEEtran.bst IEEEtran.cls \#article.org\#
