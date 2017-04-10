# ex-graphviz
XQuery interface for Graphviz with EXPath packaging.

## Prerequisites
Requires [Graphviz](http://www.graphviz.org/) to be installed.
 `dot` must be on the path or the GVPATH environment variable to be set to the folder containing `dot`
## Usage 
````
import module namespace ex-graphviz="expkg-zone58:image.graphviz";

ex-graphviz:to-svg("digraph {a -> b}")
````
##  Build
Creates `dist/ex-graphviz.xar`
````
basex build.xq
````
## Test
````
basex -t src/test/basic.xq
````
## History
* versions prior to 0.3.0 used the namespace http://expkg-zone58.github.io/ex-graphviz