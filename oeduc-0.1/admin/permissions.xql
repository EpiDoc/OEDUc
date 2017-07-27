xquery version "3.0";

import module namespace xdb = "http://exist-db.org/xquery/xmldb";

(: changes the permission on the files to allow guest to edit (write permission on third level):)
for $resource in collection('/db/apps/OEDUc/data/') 
return sm:chmod(xs:anyURI(base-uri($resource)), 'rw-rw-rw-')