LABS=labs.adoc \
    content/overview/overview.adoc \
    content/chapter1/chapter1.adoc \
    content/chapter2/chapter2.adoc \
    content/chapter3/chapter3.adoc \
    content/chapter4/chapter4.adoc \
    content/chapter5/chapter5.adoc \
    content/chapter6/chapter6.adoc \
    content/chapter7/chapter7.adoc \
    content/appendix/appendix.adoc

all: $(LABS) labs

labs: $(LABS)
	asciidoc -v labs.adoc
	a2x -fpdf -dbook --fop --no-xmllint -v labs.adoc
	$(foreach lab,$(LABS), asciidoc -v $(lab);)

html: $(LABS) 
	asciidoc -v labs.adoc
	asciidoc --backend 
	$(foreach lab,$(LABS), asciidoc -v $(lab);)

pdf: $(LABS) 
	a2x -fpdf -dbook --fop --no-xmllint -v labs.adoc

epub: $(LABS) $(SLIDES)
	a2x -fepub -dbook --no-xmllint -v labs.adoc

clean:
	find . -type f -name \*.html -exec rm -f {} \;
	find . -type f -name \*.pdf -exec rm -f {} \;
	find . -type f -name \*.epub -exec rm -f {} \;
	find . -type f -name \*.fo -exec rm -f {} \;
	find . -type f -name \*.xml -exec rm -f {} \;
