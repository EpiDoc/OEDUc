xquery version "3.1";


declare namespace t = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";


let $name := request:get-parameter("id", "")
let $id := substring-after($name, 'OEDUc')

let $data-collection := '/db/apps/OEDUc/data/'
let $doc := concat($data-collection, $id, '.xml')

return
<html>
    <head>
        <title>Delete Confirmation</title>
        <style>
        <![CDATA[
        .warn {background-color: silver; color: black; font-size: 16pt; line-height: 24pt; padding: 5pt; border: solid 2px black;}
        ]]>
        </style>
    </head>
    <body>
         <h1>Are you sure you want to delete this inscription?</h1>
        <strong>Name: </strong>{doc($doc)/t:title/text()}<br/>
        <strong>text: </strong> {let $params := <parameters>
    <param name="internal-app-style" value="none"/>
    <param name="external-app-style" value="default"/>
    <param name="edn-structure" value="default"/>
    <param name="parm-edition-type" value="interpretative"/>
    <param name="leiden-style" value="panciera"/>
    <param name="line-inc" value="5"/>
</parameters>
return
<p>{
transform:transform(doc($doc)/t:div[@type="edition"], 'xmldb:exist:///db/apps/OEDUc/EpiDocXslt/oeductext.xsl',$params)}</p>
}<br/>
        <br/>
        <a class="warn" href="/exist/apps/OEDUc/edit/delete.xq?id={$id}">Yes - Delete This Inscription</a>
        <br/>
        <br/>
        <a  class="warn" href="/exist/apps/OEDUc/inscription/{$name}">Cancel (Back to View Inscription)</a>
    </body>
</html>
