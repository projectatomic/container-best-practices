LABS=labs.adoc \
    content/lab1/lab1.labs.adoc \
    content/lab2/lab2.labs.adoc \
    content/lab3/lab3.labs.adoc \
    content/lab4/lab4.labs.adoc \
    content/lab5/lab5.labs.adoc \
    content/lab6/lab6.labs.adoc \
    content/lab7/lab7.labs.adoc

# SLIDES=slides.adoc \
    content/lab1/lab1.slides.adoc \
    content/lab2/lab2.slides.adoc \
    content/lab3/lab3.slides.adoc \
    content/lab4/lab4.slides.adoc \
    content/lab5/lab5.slides.adoc 

all: $(LABS) $(SLIDES) labs slides 

labs: $(LABS)
	asciidoc -v labs.adoc
	a2x -fpdf -dbook --fop --no-xmllint -v labs.adoc
	$(foreach lab,$(LABS), asciidoc -v $(lab);)

slides: $(SLIDES)
	asciidoc --backend slidy -v slides.adoc
	$(foreach slide,$(SLIDES), asciidoc --backend slidy -v $(slide);)
#	a2x -fpdf -dbook --fop --no-xmllint -v slides.adoc	# commented out as SVG causes compile fail

html: $(LABS) $(SLIDES)
	asciidoc -v labs.adoc
	asciidoc --backend slidy -v slides.adoc
	$(foreach lab,$(LABS), asciidoc -v $(lab);)
	$(foreach slide,$(SLIDES), asciidoc --backend slidy -v $(slide);)

pdf: $(LABS) $(SLIDES)
	a2x -fpdf -dbook --fop --no-xmllint -v labs.adoc
#	a2x -fpdf -dbook --fop --no-xmllint -v slides.adoc	# commented out as SVG causes compile fail

epub: $(LABS) $(SLIDES)
	a2x -fepub -dbook --no-xmllint -v labs.adoc
	a2x -fepub -dbook --no-xmllint -v slides.adoc

clean:
	find . -type f -name \*.html -exec rm -f {} \;
	find . -type f -name \*.pdf -exec rm -f {} \;
	find . -type f -name \*.epub -exec rm -f {} \;
	find . -type f -name \*.fo -exec rm -f {} \;
	find . -type f -name \*.xml -exec rm -f {} \;
