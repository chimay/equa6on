# vim: set ft=make :

include Makefile.inc

.DEFAULT_GOAL := all

# phony {{{1

.PHONY: debug

.PHONY: org-html tex-pdf tex-html

.PHONY: dry-sync sync

.PHONY: all install

.PHONY: $(ORG_HTML_SUBDIRS) $(TEX_PDF_SUBDIRS) $(TEX_HTML_SUBDIRS)
.PHONY: $(CLEAN_SUBDIRS) $(CLEAN_HTML_SUBDIRS) $(WIPE_SUBDIRS)

.PHONY: clean clean-html wipe

# debug {{{1

$(DEBUG_SUBDIRS):
	$(MAKE) -C ${@:debug-%=%} debug
	@$(ECHO)

debug: $(DEBUG_SUBDIRS)
	@echo $(ALL_TEX_FILES)

# index {{{1

index-html.org: ~/racine/public/eclats2vers/generic/matemat/index.org
	$(RSYNC) ~/racine/public/eclats2vers/generic/matemat/index.org index-html.org
	@$(ECHO)

index.org: index-html.org
	sed 's-\[\[file:\([^]]\+\).org\]-[[file:pdf/\1.pdf]-' index-html.org > index.org

README.org: index.org
	cp index.org README.org

# sync {{{1

dry-sync:
	$(DRY_RSYNC) ~/racine/public/eclats2vers/generic/matemat/pdf/*.pdf pdf
	@$(ECHO)

sync:
	$(RSYNC) ~/racine/public/eclats2vers/generic/matemat/pdf/*.pdf pdf
	@$(ECHO)

# all, install {{{1

all: sync README.org
	git add -A

install: sync

# clean, wipe {{{1

$(CLEAN_SUBDIRS):
	$(MAKE) -C ${@:clean-%=%} clean
	@$(ECHO)

$(CLEAN_HTML_SUBDIRS):
	$(MAKE) -C ${@:clean-html-%=%} clean-html
	@$(ECHO)

$(WIPE_SUBDIRS):
	$(MAKE) -C ${@:wipe-%=%} wipe
	@$(ECHO)

clean: $(CLEAN_SUBDIRS)
	rm -f ?*~ ?*.log ?*.aux ?*.out ?*.toc ?*.dvi ?*.fls ?*.fdb_latexmk

clean-html: $(CLEAN_HTML_SUBDIRS)
	rm -f ?*~ ?*.html

wipe: clean $(WIPE_SUBDIRS)
	rm -f ?*~ ?*.html ?*.pdf
