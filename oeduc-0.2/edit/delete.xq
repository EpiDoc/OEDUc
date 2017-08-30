xquery version "1.0";

declare option exist:serialize "method=xhtml media-type=text/html indent=yes";
 
let $data-collection := '/db/apps/OEDUc/data'
 
(: get the id parameter from the URL :)
let $id := request:get-parameter('id', '')

(: log into the collection :)

(: construct the filename from the id :)
let $file := concat($id, '.xml')

(: delete the file :)
let $store := xmldb:remove($data-collection, $file)

return
<html>
    <head>
        <title>Delete Inscription</title>
        <style>
            <![CDATA[
               .warn  {background-color: silver; color: black; font-size: 16pt; line-height: 24pt; padding: 5pt; border:solid 2px black;}
            ]]>
        </style>
    </head>
    <body>
        <a href="../index.xhtml">Home</a> 
        <a href="../list.html">List Inscriptions</a><br/>
        <h1>Inscription {$id} has been removed.</h1>
    </body>
</html>