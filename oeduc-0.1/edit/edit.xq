xquery version "3.1"  encoding "UTF-8";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare option exist:serialize "method=xhtml media-type=text/xml indent=yes process-xsl-pi=no";

let $new := request:get-parameter('new', '')
let $id := request:get-parameter('id', '')
let $data-collection := '/db/apps/OEDUc/data/'

let $file := if ($new='true') then 
        'new-instance.xml'
    else 
        collection($data-collection)//id($id)
(:this will match tei:entry:)

return
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <link
                    rel="shortcut icon"
                    href="resources/images/favicon.ico"/>
                <meta
                    name="viewport"
                    content="width=device-width, initial-scale=1.0"/>
                <link
                    rel="shortcut icon"
                    href="resources/images/minilogo.ico"/>
                <link
                    rel="stylesheet"
                    type="text/css"
                    href="$shared/resources/css/bootstrap-3.0.3.min.css"/>
                <link
                    rel="stylesheet"
                    href="resources/font-awesome-4.7.0/css/font-awesome.min.css"/>
                <link
                    rel="stylesheet"
                    type="text/css"
                    href="resources/css/style.css"/>
                <script
                    xmlns=""
                    type="text/javascript"
                    src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
                <script
                    type="text/javascript"
                    src="$shared/resources/scripts/loadsource.js"></script>
                <script
                    type="text/javascript"
                    src="$shared/resources/scripts/bootstrap-3.0.3.min.js"></script>
                
       <title>Edit Item</title>
        
       
    </head>
    <body>
                <h1>Edit Inscription</h1>
                <form id="updateEntry" action="{if ($new='true') then ('save-new.xq') else ('update.xq')}" >
                <div class="form-group">
                <input hidden="hidden" value="{$id}" name="id"/>
            <label for="form" class="col-md-2 col-form-label">Form</label>
            <div class="col-md-10">
                <textarea class="form-control" id="form" name="form" required="required">{transform:transform($file//tei:ab, 'xmldb:exist:///db/apps/OEDUc/xslt/xml2editor.xsl', ())}</textarea>
                
            </div>
        </div>
     
        <button id="confirmcreatenew" type="submit" class="btn btn-primary">update entry</button>
                </form>
    </body>
</html>
            