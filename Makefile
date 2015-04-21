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
    content/openshift/openshift.adoc \
    content/atomic_app/atomic_app.adoc \
    content/appendix/appendix.adoc \
    content/references/references.adoc

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
