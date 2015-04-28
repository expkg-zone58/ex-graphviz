(:~
 : ex-graphviz tests
 :)
module namespace test = 'http://basex.org/modules/xqunit-tests';
import module namespace gr="quodatum.ex-graphviz";

declare %unit:test
(:~
 : check simple diagram generates svg
 :) 
function  test:simple(){
  let $s:=gr:dot("digraph {a -> b}","")
  return unit:assert-equals(name($s),"svg")
};
