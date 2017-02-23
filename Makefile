######################################################################
# Makefile helper to pelican static site generator                   #
######################################################################
REPOSITORY ?= niamtokik.github.io
GITHUB ?= git@github.com:niamtokik/$(REPOSITORY).git
WEBSITE ?= website

.ifndef EDITOR
EDITOR := mg
.endif

######################################################################
# usage
######################################################################
help:
	@echo "usage: make [init|prod|dev|deploy]"

######################################################################
# build prod release: need pelicanconf.py
######################################################################
prod: $(REPOSITORY)
	./bin/pelican -o $(REPOSITORY)

######################################################################
# build dev release: need pelicanconf_dev.py
######################################################################
dev: pelicanconf_dev.py
	./bin/pelican -s pelicanconf_dev.py -o $(REPOSITORY)_dev

pelicanconf_dev.py:
	@echo "error! pelicanconf_dev.py doesn't exist!"

######################################################################
# repository clone
######################################################################
$(REPOSITORY):
	git clone $(GITHUB)

######################################################################
# init functions
######################################################################
init: bootstrap init-plugins init-themes init-website init-template

init-plugins: pelican-plugins

init-themes: pelican-themes

init-website: website/content/category website/content/pages

init-template: template/page.asciidoc template/article.asciidoc

######################################################################
# website directory
######################################################################
website:
	mkdir $@

website/content: website
	mkdir $@

website/content/category: website/content
	mkdir $@

website/content/pages: website/content
	mkdir $@

######################################################################
# template directory
######################################################################
template:
	mkdir template

template/page.asciidoc: template
	touch $@

template/article.asciidoc: template
	touch $@

######################################################################
# pelican external plugin: need git
######################################################################
pelican-plugins:
	git clone https://github.com/getpelican/pelican-plugins.git

######################################################################
# pelican external themes: need git
######################################################################
pelican-themes:
	git clone https://github.com/niamtokik/pelican-themes.git

######################################################################
# article and page creation helper
######################################################################
.ifndef TITLE
TITLE != date +"%Y-%m-%dT%H:%M:%S"
.endif
article:
	touch $(WEBSITE)/$(TITLE).asciidoc
	$(EDITOR) $(WEBSITE)/$(TITLE).asciidoc

page:
	touch $(WEBSITE)/pages/$(TITLE).asciidoc
	$(EDITOR) $(WEBSITE)/pages/$(TITLE).asciidoc

######################################################################
# python virtualenv bootstrap helper
######################################################################
bootstrap:
	virtualenv .
	./bin/pip install pelican

######################################################################
# deploy repository in production: need git
######################################################################
deploy: prod
	cd $(REPOSITORY) && \
		git add . && \
		git commit -m "automatic deploy from Makefile" && \
		git push
