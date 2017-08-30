xquery version "3.0";

import module namespace xdb = "http://exist-db.org/xquery/xmldb";


let $login := xmldb:login('/db/', 'admin', '')
(: changes the permission on the files to allow guest to edit (write permission on third level):)
let $collection := (sm:chmod(xs:anyURI('/db/apps/OEDUc/data/'), 'rw-rw-rw-'),sm:chgrp(xs:anyURI('/db/apps/OEDUc/data/'), 'guest'))
let $edit := (sm:chmod(xs:anyURI('/db/apps/OEDUc/data/'), 'rw-rw-rw-'),sm:chgrp(xs:anyURI('/db/apps/OEDUc/data/'), 'guest'))
let $resources := for $resource in collection('/db/apps/OEDUc/data/') 
return sm:chmod(xs:anyURI(base-uri($resource)), 'rw-rw-rw-')
return
    'updated'