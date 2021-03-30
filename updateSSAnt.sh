#!/usr/bin/bash

WAX_HOME=`pwd`

# build the wax site for indexing
bundle exec jekyll build

# remove the IIIF tiles directories (so staticSearch won't crawl them)
rm -r _site/img/derivatives/iiif/images

# remove the staticSearch artefacts so they'll be regenerated
rm -r _site/ssIndex

# run html tidy on generated html pages to get proper xhtml for indexing
find _site -name \*.html | grep -v _site/search.html | xargs -n 1 tidy -mq -asxhtml --drop-empty-elements no --numeric-entities yes

# run staticSearch to do the indexing
docker run -v "$WAX_HOME/_site:/site" ant

# copy the staticSearch artefacts up from _site
rsync -a --delete _site/ssIndex ./

# serve the site
bundle exec jekyll serve
