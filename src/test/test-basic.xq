(:~
 : ex-graphviz tests
 :)
module namespace test = 'http://basex.org/modules/xqunit-tests';
import module namespace ex-graphviz="http://expkg-zone58.github.io/ex-graphviz";

declare %unit:test
(:~
 : check simple diagram generates svg
 :) 
function  test:simple(){
  let $s:=ex-graphviz:to-svg("digraph {a -> b}")/*
  return unit:assert-equals(name($s),"svg")
};
