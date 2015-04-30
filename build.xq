(: create o/ps
 : xar package and xqdoc
 :)
declare namespace pkg="http://expath.org/ns/pkg";

declare variable $src:=resolve-uri("src/main/");
declare variable $dest:=resolve-uri("dist/");

declare variable $package:=doc(resolve-uri("expath-pkg.xml",$src))/*;

 declare function local:read($name){
   trace($name),
  let $f:=fn:resolve-uri( translate($name,"\","/"),$src)
  return  file:read-binary($f)
 };
 
let $files:=file:list($src,fn:true()) 
let $data:= $files!local:read(.)
let $zip   := archive:create( $files, $data)
let $name:= concat($package/@name , "-" ,$package/@version, ".xar")
return ( file:write-binary(resolve-uri($name,$dest),$zip)
         ,file:write(resolve-uri("xqdoc.xml",$dest),inspect:xqdoc(resolve-uri("src/main/content/graphviz.xqm")))
     
)
