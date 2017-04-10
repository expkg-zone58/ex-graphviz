(:~
: Wrapper for using  <a href="graphviz.org">Graphviz</a>.
: It requires the Graphviz executables are available on path or in folder located by $GVPATH
: @version 0.3.0
: @author Andy Bunce 
:)

module namespace ex-graphviz="expkg-zone58:image.graphviz";


import module namespace proc="http://basex.org/modules/proc";
import module namespace file="http://expath.org/ns/file";

declare namespace svg= "http://www.w3.org/2000/svg";
declare namespace xlink="http://www.w3.org/1999/xlink";


(:~
 : SVG to return when supplied dot string is empty
 :)                                      
declare %private variable $ex-graphviz:empty:=document{
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 20" version="1.1" 
width="100%" height="100%" preserveAspectRatio="xMidYMid meet">
   <text x="150" y="10"  text-anchor="middle">Empty.</text>
</svg>
};


(:~
: Layout graph in the DOT language and return as SVG
: @return svg document
:)
declare function ex-graphviz:to-svg( $dot as xs:string) 
as document-node()
{
    ex-graphviz:to-svg( $dot, ()) 
};

(:~
:Layout  graph given in the DOT language and render  as SVG.
: @param $dot dot string
: @param $params additional arguments supplied to executable
: @return svg document
:@error ex-graphviz:exec error running executable
:)
declare function ex-graphviz:to-svg( $dot as xs:string, $params as xs:string*) 
as document-node()
{
   let $params:=("-Tsvg")
   return if(fn:not($dot))
           then $ex-graphviz:empty
           else let $r:=ex-graphviz:dot-execute($dot,$params)
                return document{fn:parse-xml($r/output)}
};
(:~ run dot command
 : @param $dot dot string
 : @param $params additional arguments supplied to executable
 : @return  
 :@error ex-graphviz:exec error running executable
:)
declare %private function ex-graphviz:dot-execute( $dot as xs:string, $params as xs:string*) 
as element(result)
{
    let $fname:=file:create-temp-file("graphviz","")
    let $junk:=file:write-text($fname,$dot)
    let $r:=proc:execute(ex-graphviz:exe("dot") , ($params,$fname))
    let $junk:=file:delete($fname)
    return if($r/code!="0")
           then  fn:error(xs:QName('ex-graphviz:exec'),$r/error) 
           else $r
};

(:~ run dot command  returning binary
 : @param $dot dot string
 : @param $params additional arguments supplied to executable 
 :@error ex-graphviz:exec error running executable 
:)
declare  function ex-graphviz:dot-executeb( $dot as xs:string, $params as xs:string*) 
as xs:base64Binary
{
    let $fname:=file:create-temp-file("graphviz","")
    let $oname:=$fname || ".o"
    let $junk:=file:write-text($fname,$dot)
    let $r:=proc:execute(ex-graphviz:exe("dot") , ($params,"-o"|| $oname,$fname))
    let $junk:=file:delete($fname)
    return if($r/code!="0")
           then  fn:error(xs:QName('ex-graphviz:exec'),$r/error) 
           else  let $d:=stream:materialize(file:read-binary($oname))
                 let $junk:=file:delete($oname) 
                 return $d                  
};

(:~ cleanup dot svg result :)
declare  function ex-graphviz:clean( $doc as document-node()) 
as element(svg:svg)
{ 
    let $ver:=$doc/comment()[1]/fn:normalize-space()
    let $title:=$doc/comment()[2]/fn:normalize-space()
    let $svg:=$doc/*
    return   <svg xmlns="http://www.w3.org/2000/svg" 
    xmlns:xlink="http://www.w3.org/1999/xlink" >
  {$svg/@* ,
   ex-graphviz:rdf($title,$ver),
  $svg/*}
  </svg>
 
};

(:~
 : Generate metadata RDF for operation suitable for inclusion in SVG
 :)
declare function ex-graphviz:rdf($title as xs:string,
                    $ver as xs:string) 
as element(svg:metadata)
{
 <svg:metadata>
    <rdf:RDF
           xmlns:rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
           xmlns:rdfs = "http://www.w3.org/2000/01/rdf-schema#"
           xmlns:dc = "http://purl.org/dc/elements/1.1/" >
        <rdf:Description about="http://expkg-zone58.github.io/ex-graphviz"
             dc:title="{$title}"
             dc:description="A graph visualization"
             dc:date="{fn:current-dateTime()}"
             dc:format="image/svg+xml">
          <dc:creator>
            <rdf:Bag>
              <rdf:li>{$ver}</rdf:li>
              <rdf:li resource="http://expkg-zone58.github.io/ex-graphviz"/>
            </rdf:Bag>
          </dc:creator>
        </rdf:Description>
      </rdf:RDF>
      </svg:metadata>
};

(:~
: Tweak svg to autosize to 100%, assumes svg is from graphviz and viewBox is set.
:)
declare function ex-graphviz:autosize($svg as element(svg:svg)) 
as element(svg:svg)
{
  <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
  width="100%" height="100%" preserveAspectRatio="xMidYMid meet">
  {$svg/@* except ($svg/@width,$svg/@height,$svg/@preserveAspectRatio),
  $svg/*}
  </svg>
};
(:~
: graphviz executable.
:)
declare %private function ex-graphviz:exe($name as xs:string) 
as xs:string
{
 if(fn:environment-variable("GVPATH")) then 
    file:resolve-path($name,fn:environment-variable("GVPATH"))
 else 
    $name
};

