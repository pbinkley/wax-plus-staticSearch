---
layout: page
title: Notes on staticSearch implementation
permalink: /staticSearch-notes/
---

### Steps for a minimal implementation

- [Install staticSearch](https://endings.uvic.ca/staticSearch/docs/howDoIGetIt.html). Note that ```ant-contrib``` is a jar file, which you copy into Ant's ```/lib``` directory.
- add ```staticSearch-config.xml``` and ```search.html``` and ```dicts``` folder to Wax site (this has already been done in this demo)
- Generate Wax site:
```
bundle exec jekyll build
```
- remove the IIIF images directory (so that staticSearch won't crawl it - see [my issue](https://github.com/projectEndings/staticSearch/issues/90))
```
mv _site/img/derivatives/iiif/images ../
```
- tidy the Wax html files to get good XHTML, using HTML Tidy
```
find _site -name \*.html | xargs -n 1 tidy -mq -asxhtml --drop-empty-elements no --numeric-entities yes
```
- in staticSearch home, run the indexing job
```
ant -DconfigFile=/path/to/wax-master/_site/staticSearch-config.xml
```
That generates a [report]({{ '/ssTest/staticSearch_report.html' | relative_url }}) (and opens it in your browser), and generates the index artefacts in ```ssTest```, and updates ```search.html```.
- in Jekyll home, copy the index artefacts up to the Wax site
```
cp -r _site/ssTest ./
cp _site/search.html ./
```
- we can now serve the Wax site as usual
```
bundle exec jekyll serve
```
- visit [search.html?q=qatar]({{ '/search.html?q=qatar' | relative_url }})

We can now add features to ```staticSearch-config.xml```.


### Notes

- Firefox does't like the ```<![CDATA[ ]]>``` wrapping in a ```script``` element (it's ok in css though) - is this from tidy, or from the xsl?