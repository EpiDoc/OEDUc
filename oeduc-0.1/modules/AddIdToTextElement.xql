xquery version "3.1" encoding "UTF-8";

declare namespace t = "http://www.tei-c.org/ns/1.0";
declare namespace s = "http://www.w3.org/2005/xpath-functions";
declare namespace sparql = "http://www.w3.org/2005/sparql-results#";

(:uses the update extension of XQuery to add the name of the file as xml id inside the element text:)
for $r in collection('/db/apps/OEDUc/data/EDH/')
let $id := substring-before(util:document-name($r), '.xml')
return
update insert attribute xml:id {$id} into $r//t:text