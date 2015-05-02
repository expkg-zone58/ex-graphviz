(: create o/ps
 : xar package and xqdoc
 :)
declare namespace pkg="http://expath.org/ns/pkg";

declare variable $src:=resolve-uri("src/main/");
declare variable $dest:=resolve-uri("dist/");

declare variable $package:=doc(resolve-uri("expath-pkg.xml",$src))/pkg:package;

(:~
 : file paths below $src
 :)
 declare function local:files() as xs:string*
 {
   filter(file:list($src,fn:true()),
          function ($f){file:is-file($src || $f)}
        )
          !translate(.,"\","/") 
 };
 
 declare function local:zip(
                            $files as xs:string*
                            ) as xs:base64Binary
 {
  let $data:= $files!file:read-binary(fn:resolve-uri( .,$src))
  return archive:create( $files, $data) 
 };
 
 declare function local:save-xqdoc($path as xs:string){
  let $xqdoc:=inspect:xqdoc(resolve-uri("content/" || $path,$src))
  let $target:=resolve-uri($path || ".xml",$dest)
  return file:write($target,$xqdoc) 
};
let $files:=local:files() 
let $xar:= local:zip($files)
let $name:= concat($package/@abbrev , "-" ,$package/@version, ".xar")
let $xq:=resolve-uri("content/" ||$package/pkg:xquery/pkg:file,$src)
return ( file:write-binary(resolve-uri($name,$dest),$xar),
         $package/pkg:xquery/pkg:file!local:save-xqdoc(.)  
)

