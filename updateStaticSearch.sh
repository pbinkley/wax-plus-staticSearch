#!/usr/bin/bash

STATICSEARCH_HOME=../staticSearch
WAX_HOME=`pwd`

# build the wax site for indexing
bundle exec jekyll build

# remove the IIIF tiles directories (so staticSearch won't crawl them)
rm -r _site/img/derivatives/iiif/images

# remove the staticSearch artefacts so they'll be regenerated
rm -r _site/testSS

# run html tidy on generated html pages to get proper xhtml for indexing
find _site -name \*.html | grep -v _site/search.html | xargs -n 1 tidy -mq -asxhtml --drop-empty-elements no --numeric-entities yes

# run staticSearch to do the indexing
cd $STATICSEARCH_HOME
ant -DconfigFile=$WAX_HOME/_site/staticSearch-config.xml

# return to Wax, copy the staticSearch artefacts up from _site
cd $WAX_HOME
rsync -a --delete _site/ssTest ./

# serve the site
bundle exec jekyll serve
