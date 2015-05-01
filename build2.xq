(: create o/ps
 : xar package and xqdoc
 :)
declare namespace pkg="http://expath.org/ns/pkg";

declare variable $src:=resolve-uri("src/main/");
declare variable $dest:=resolve-uri("dist/");

declare variable $package:=doc(resolve-uri("expath-pkg.xml",$src))/*;

(:~
 : file paths below $src
 :)
 declare function local:files($src) as xs:string*
 {
   filter(file:list($src,fn:true()),
          file:is-file#1
        )
          !translate(.,"\","/") 
 };
 
 declare function local:zip($files,$src) as xs:base64Binary
 {
  let $data:= $files!file:read-binary(fn:resolve-uri( .,$src))
  return archive:create( $files, $data) 
 };
 
let $files:=local:files($src) 
let $xar:= local:zip($files,$src)
let $name:= concat($package/@name , "-" ,$package/@version, ".xar")
let $xq:=resolve-uri("content/" ||$package/xquery/file,$src)
return ( file:write-binary(resolve-uri($name,$dest),$xar)
         ,for $f in $package/xquery/file
         (:  let $xqdoc:=inspect:xqdoc(resolve-uri("content/" || $f,$src))
          let $target:=resolve-uri($f || ".xml",$dest)
         return file:write($target,$xqdoc) :)
         return $f
     
)
