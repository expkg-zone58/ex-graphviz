# ex-graphviz
XQuery interface for Graphviz with EXPath packaging.

## Prerequisites
Requires [Graphviz](http://www.graphviz.org/) to be installed.
 `dot` must be on the path or the DOTPATH evironment variable to be set to the location of `dot`

##  Build
Creates `dist/ex-grapviz.zar`
````
basex build.xq
````
## Test
````
basex -t srs/test/test.xq
````