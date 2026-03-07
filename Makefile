PYTHON ?= python3
MKDOCS ?= $(PYTHON) -m mkdocs
MIKE ?= mike
MKDOCS_CONFIG ?= mkdocs.yml
SITE_DIR ?= site

.PHONY: help build html serve strict mike-latest mike-serve clean pdf epub

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  html/build  to build the MkDocs site into $(SITE_DIR)/"
	@echo "  serve       to run the local MkDocs development server"
	@echo "  strict      to build the MkDocs site with --strict"
	@echo "  mike-latest to run 'mike deploy latest' for the versioned docs"
	@echo "  mike-serve  to run 'mike serve' for local multi-version preview"
	@echo "  clean       to remove generated MkDocs output"
	@echo "  pdf         unsupported in the current MkDocs setup"
	@echo "  epub        unsupported in the current MkDocs setup"

build html:
	$(MKDOCS) build --config-file $(MKDOCS_CONFIG)

serve:
	$(MKDOCS) serve --config-file $(MKDOCS_CONFIG)

strict:
	$(MKDOCS) build --strict --config-file $(MKDOCS_CONFIG)

mike-latest:
	$(MIKE) deploy latest

mike-serve:
	$(MIKE) serve

clean:
	rm -rf $(SITE_DIR)

pdf epub:
	@echo "Offline PDF/EPUB output is not configured for the root MkDocs project."
	@echo "Read the Docs only provides built-in pdf/epub/htmlzip formats for Sphinx,"
	@echo "and this repository does not currently ship an alternate MkDocs export toolchain."
	@exit 1
