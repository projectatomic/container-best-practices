ifneq ($(COMMIT_ID),)
	DO_COMMIT_ID = '--commit=$(COMMIT_ID)'
endif

SHELL := /bin/bash
LABS=index.adoc \
	overview/overview_index.adoc \
	terminology/terminology_index.adoc \
	planning/planning_index.adoc \
	creating/creating_index.adoc \
	building/building_index.adoc \
	testing/testing_index.adoc \
	maintaining/maintaining_index.adoc \
	delivering/delivering_index.adoc

ALL_ADOC_FILES := $(shell find . -type f -name '*.adoc')

all: $(LABS) labs

labs: $(LABS)
	asciidoctor -a linkcss -a stylesheet=http://www.projectatomic.io/stylesheets/application.css index.adoc
	#a2x -fpdf -dbook --fop --no-xmllint -v labs.asciidoc
	$(foreach lab,$(LABS), asciidoctor -a linkcss -a stylesheet=http://www.projectatomic.io/stylesheets/application.css $(lab);)

html:
	# asciidoctor can only put a single HTML output
	# chunked output is close per upstream
	asciidoctor -d book -a linkcss -a stylesheet=http://www.projectatomic.io/stylesheets/application.css index.adoc

plain-html:
	asciidoctor index.adoc

publish: $(LABS)
	git branch -D gh-pages
	asciidoctor -a linkcss -a stylesheet=http://www.projectatomic.io/stylesheets/application.css index.adoc
	git checkout -b gh-pages
	git commit index.html -m "Update"
	git push origin gh-pages -f

pdf: $(LABS) 
	#a2x -fpdf -dbook --fop --no-xmllint -v index.adoc
	asciidoctor -r asciidoctor-pdf -b pdf -o container_best_practices.pdf index.adoc

epub: $(LABS) $(SLIDES)
	a2x -fepub -dbook --no-xmllint -v index.adoc

check:
	# Disabled for now
	#@for docsrc in $(ALL_ADOC_FILES); do \
	#	echo -n "Processing '$$docsrc' ..."; \
	#	cat $$docsrc | aspell -a --lang=en \
	#				 --dont-backup \
	#				 --personal=./containers.dict | grep -e '^&'; \
	#	[ "$$?" == "0" ] && exit 1 || echo ' no errors.'; \
	#done
	echo "Disabled"

toc:
	asciidoctor index.adoc
	python toc.py

clean:
	find . -type f -name \*.html -exec rm -f {} \;
	find . -type f -name \*.pdf -exec rm -f {} \;
	find . -type f -name \*.epub -exec rm -f {} \;
	find . -type f -name \*.fo -exec rm -f {} \;
	find . -type f -name \*.xml -exec rm -f {} \;
	rm -fr output/

review:
	python mark_change.py ${ALL_ADOC_FILES} ${DO_COMMIT_ID}
	cd output && asciidoctor index.adoc

