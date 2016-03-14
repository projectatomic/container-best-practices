# Container Best Practices Guide
[![Build Status](https://travis-ci.org/projectatomic/container-best-practices.svg?branch=master)](https://travis-ci.org/projectatomic/container-best-practices) [![Docs](https://img.shields.io/badge/docs-asciidoc-blue.svg)](http://docs.projectatomic.io/container-best-practices/)

A collaborative project to document container-based application architecture, creation and management.  The built version of this source can be viewed at http://docs.projectatomic.io/container-best-practices/

## Contributing

Please refer to the asciidoc user's guide: http://asciidoctor.org/docs/asciidoc-writers-guide/

Before submitting a pull request:

1. Compile the document, `make html`
1. run `make check` to spellcheck the documents. Update personal dictionary file `containers.dict` with any non-English words.

## Working with files

### Compile docs from a container

Create local `index.html` file

```
sudo docker run --rm -it -v `pwd`:/documents/:Z asciidoctor/docker-asciidoctor make html
```

### Clean up files

```
make clean
```

This removes all generated files.

### Publish

```
make publish
```

Github serves HTML documents from the `gh-pages` branch. This command will push to the branch.

### Spell check

`aspell` is used to spell check the document. This is run in a [Travis job](https://travis-ci.org/projectatomic/container-best-practices) for all pull requests. Any non-English words should be added to `containers.dict` with your commit. Ensure `make check` passes.
