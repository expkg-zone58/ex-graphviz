(:~
 : ex-graphviz tests
 :)
module namespace test = 'http://basex.org/modules/xqunit-tests';
import module namespace ex-graphviz="expkg-zone58:image.graphviz" at "../main/content/graphviz.xqm";

declare %unit:test
(:~
 : check simple diagram generates svg
 :) 
function  test:simple(){
  let $s:=ex-graphviz:to-svg("digraph {a -> b}")/*
  return unit:assert-equals(name($s),"svg")
};
