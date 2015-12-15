SHELL := /bin/bash
LABS=index.asciidoc \
    overview/overview.adoc \
    plan/index.adoc \
	create/general_guidelines.adoc \
	create/references.adoc

all: $(LABS) labs

labs: $(LABS)
	asciidoctor -a linkcss -a stylesheet=http://www.projectatomic.io/stylesheets/application.css index.asciidoc
	a2x -fpdf -dbook --fop --no-xmllint -v labs.asciidoc
	$(foreach lab,$(LABS), asciidoctor -a linkcss -a stylesheet=http://www.projectatomic.io/stylesheets/application.css $(lab);)

html: $(LABS)
	asciidoctor -a linkcss -a stylesheet=http://www.projectatomic.io/stylesheets/application.css index.asciidoc
	# remove until document structure is sorted out
	#$(foreach lab,$(LABS), asciidoctor -a linkcss -a stylesheet=http://www.projectatomic.io/stylesheets/application.css $(lab);)

publish: $(LABS)
	git branch -D gh-pages
	asciidoctor -a linkcss -a stylesheet=http://www.projectatomic.io/stylesheets/application.css index.asciidoc
	git checkout -b gh-pages
	git commit index.html -m "Update"
	git push origin gh-pages -f

pdf: $(LABS) 
	a2x -fpdf -dbook --fop --no-xmllint -v index.asciidoc

epub: $(LABS) $(SLIDES)
	a2x -fepub -dbook --no-xmllint -v index.asciidoc

check:
	@for docsrc in $(LABS); do \
		echo -n "Processing '$$docsrc' ..."; \
		cat $$docsrc | aspell -a --lang=en \
					 --dont-backup \
					 --personal=./containers.dict | grep -e '^&'; \
		[ "$$?" == "0" ] && exit 1 || echo ' no errors.'; \
	done

clean:
	find . -type f -name \*.html -exec rm -f {} \;
	find . -type f -name \*.pdf -exec rm -f {} \;
	find . -type f -name \*.epub -exec rm -f {} \;
	find . -type f -name \*.fo -exec rm -f {} \;
	find . -type f -name \*.xml -exec rm -f {} \;
