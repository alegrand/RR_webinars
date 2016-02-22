ARCHIVE=replicable
ARCHIVE_FILES=$(shell git ls-tree -r master --name-only | grep -v -e 'article.pdf')

all: article.pdf

%.tex: %.org
	emacs -q -batch --eval "(setq enable-local-eval t)" --eval "(setq enable-local-variables t)" \
	   --eval "(setq org-export-babel-evaluate t)" $^  --funcall org-latex-export-to-latex

%.pdf: %.tex
	pdflatex $^
	bibtex `basename $^ .tex`
	pdflatex $^
	pdflatex $^

$(ARCHIVE).tgz: $(ARCHIVE_FILES)
	tar --xform "s|^|$(ARCHIVE)/|" -zcf $@ $^
