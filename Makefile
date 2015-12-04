SHELL := /bin/bash
LABS=labs.adoc \
    content/overview/overview.adoc \
    content/location_images_dockerfiles/location_images_dockerfiles.adoc \
    content/layering/layering.adoc \
    content/image_naming/image_naming.adoc \
    content/general_guidelines/general_guidelines.adoc \
    content/dockerfile_instructions/dockerfile_instructions.adoc \
    content/layered_image_spec/layered_image_spec.adoc \
    content/base_image_spec/base_image_spec.adoc \
    content/spc/spc.adoc \
    content/middleware/middleware.adoc \
    content/docker_lint/docker_lint.adoc \
    content/openshift/openshift.adoc \
    content/scl/scl.adoc \
    content/atomic_app/atomic_app.adoc \
    content/appendix/appendix.adoc \
    content/references/references.adoc

all: $(LABS) labs

labs: $(LABS)
	asciidoctor -a linkcss -a stylesheet=http://www.projectatomic.io/stylesheets/application.css labs.adoc
	a2x -fpdf -dbook --fop --no-xmllint -v labs.adoc
	$(foreach lab,$(LABS), asciidoctor -a linkcss -a stylesheet=http://www.projectatomic.io/stylesheets/application.css $(lab);)

html: $(LABS)
	asciidoctor -a linkcss -a stylesheet=http://www.projectatomic.io/stylesheets/application.css labs.adoc
	#asciidoc --backend
	$(foreach lab,$(LABS), asciidoctor -a linkcss -a stylesheet=http://www.projectatomic.io/stylesheets/application.css $(lab);)

pdf: $(LABS) 
	a2x -fpdf -dbook --fop --no-xmllint -v labs.adoc

epub: $(LABS) $(SLIDES)
	a2x -fepub -dbook --no-xmllint -v labs.adoc

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
