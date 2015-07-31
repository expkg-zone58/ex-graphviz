# ex-graphviz
XQuery interface for Graphviz with EXPath packaging.

## Prerequisites
Requires [Graphviz](http://www.graphviz.org/) to be installed.
 `dot` must be on the path or the DOTPATH evironment variable to be set to the location of `dot`
## Usage 
````
import module namespace ex-graphviz="http://expkg-zone58.github.io/ex-graphviz";

ex-graphviz:to-svg("digraph {a -> b}")
````
##  Build
Creates `dist/ex-grapviz.zar`
````
basex build.xq
````
## Test
````
basex -t srs/test/basic.xq
````