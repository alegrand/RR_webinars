ARCHIVE=../replicable

all: article.pdf

%.tex: %.org
	emacs -q -batch --eval "(setq enable-local-eval t)" --eval "(setq enable-local-variables t)" \
	   --eval "(setq org-export-babel-evaluate t)" $^  --funcall org-latex-export-to-latex

%.pdf: %.tex
	pdflatex $^
	bibtex `basename $^ .tex`
	pdflatex $^
	pdflatex $^

$(ARCHIVE).tgz:
	tar --xform "s|^|$(ARCHIVE)/|" -zcf $@ `git ls-tree -r master --name-only | grep -v -e '.*-gz.pdf'`
