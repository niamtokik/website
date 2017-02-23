REPOSITORY ?= niamtokik.github.io
WEBSITE ?= website

.ifndef EDITOR
EDITOR := mg
.endif

clone:
	git clone $(REPOSITORY)

init:
	mkdir website
	mkdir website/content
	mkdir website/content/category
	mkdir website/content/pages
	mkdir template
	touch template/page.asciidoc
	touch template/article.asciidoc

init-plugins:
	git clone https://github.com/getpelican/pelican-plugins.git

prod:
	./bin/pelican

dev:
	./bin/pelican -s pelicanconf_dev.py

.ifndef TITLE
TITLE != date +"%Y-%m-%dT%H:%M:%S"
.endif
article:
	touch $(WEBSITE)/$(TITLE).asciidoc
	$(EDITOR) $(WEBSITE)/$(TITLE).asciidoc

page:
	touch $(WEBSITE)/pages/$(TITLE).asciidoc
	$(EDITOR) $(WEBSITE)/pages/$(TITLE).asciidoc

bootstrap:
	virtualenv .
	./bin/pip install pelican

deploy: prod
	cd $(REPOSITORY)
	git add *
	git commit
	git push
