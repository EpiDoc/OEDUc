xquery version "3.0" encoding "UTF-8";

import module namespace console = "http://exist-db.org/xquery/console";

declare namespace t = "http://www.tei-c.org/ns/1.0";
declare namespace s = "http://www.w3.org/2005/xpath-functions";
import module namespace validation = "http://exist-db.org/xquery/validation";

declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

declare variable $title := request:get-parameter('title', ());
declare variable $leidenplus := request:get-parameter('L+text', ());
let $parametersName := request:get-parameter-names()
let $copyparmeters := for $p in $parametersName
let $pv := request:get-parameter($p, ())
return $p ||'=' ||$pv
let $chainpars := string-join($copyparmeters, '&amp;')

let $app-collection := '/db/apps/OEDUc'
let $data-collection := '/db/apps/OEDUc/data'
let $next-id-file-path := concat($app-collection,'/edit/next-id.xml')
let $id := doc($next-id-file-path)/new/id/text() 
let $newid := doc($next-id-file-path)/new/id/text()
let $Newid := 'OEDUc' || $newid
let $file := concat($newid, '.xml')   


return
    if (collection($data-collection)//id($Newid)) then
        (
        <html>
            
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
                    xmlns=""
                    type="text/javascript"
                    src="http://code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
                <script
                    xmlns=""
                    type="text/javascript"
                    src="http://cdn.jsdelivr.net/jquery.slick/1.6.0/slick.min.js"></script>
                <script
                    type="text/javascript"
                    src="$shared/resources/scripts/loadsource.js"></script>
                <script
                    type="text/javascript"
                    src="$shared/resources/scripts/bootstrap-3.0.3.min.js"></script>
                
                <title>This id already exists!</title>
            </head>
            <body>
                <div
                    id="confirmation">
                    <p>Dear {xmldb:get-current-user()}, unfortunately <span
                            class="lead">{$Newid}</span> already exists!
                        Please, hit the button below and try a different id.</p>
                    <a
                        href="http://betamasaheft.aai.uni-hamburg.de:8080/exist/apps/pondera/newentry.html"
                        class="btn btn-success">back to list</a>
                </div>
            
            </body>
        </html>
        )
    else
        let $editor := switch (xmldb:get-current-user())
             case 'Pietro'
                return
                    'PL'
              case 'Charles'
                return
                    'CD'
              case 'Louise'
                return
                    'LW'
            default return
                'AP'
                (: get the form data that has been "POSTed" to this XQuery :)
    let $item :=
    document {
       
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:lang="en">
    <teiHeader>
        <fileDesc>
            <titleStmt>
                <title>{$title}</title>
            </titleStmt>  
            <publicationStmt>
                <authority>OEDUc</authority>
                <availability>
                    <licence target="http://creativecommons.org/licenses/by-sa/3.0/"></licence>
                </availability>
            </publicationStmt>
            <sourceDesc>
                <p></p>
            </sourceDesc>
        </fileDesc>
        <encodingDesc>
            <p>Marked-up according to the EpiDoc Guidelines</p>
            <classDecl>
                <taxonomy>
                    <category xml:id="representation">
                        <catDesc>Digitized other representations</catDesc>
                    </category>
                </taxonomy>
            </classDecl>
        </encodingDesc>
        <profileDesc>
            <langUsage>
               <language ident="en">English</language>
                 <language ident="grc">Ancient Greek</language>
                 <language ident="it">Italian</language>
                <language ident="la">Latin</language>
            </langUsage>
        <creation>EAGLE - Europeana Network of Ancient Greek and Latin Epigraphy</creation></profileDesc>
        <revisionDesc>
          <change
                        who="{$editor}"
                        when="{format-date(current-date(), "[Y0001]-[M01]-[D01]")}">Created entity</change>
                </revisionDesc>
            </teiHeader>
            <text>
                <body>
                       
            <div type="bibliography">
                <listBibl>
<bibl><ptr/></bibl>
                </listBibl>
            </div>
            
            <div type="edition" xml:lang="la" xml:id="{$Newid}">
            {(transform:transform(<node>{normalize-space($leidenplus)}</node>, 'xmldb:exist:///db/apps/OEDUc/xslt/upconversion.xsl', ()), console:log($leidenplus))}
            </div>
            </body>
    </text>
</TEI>
                   
                  
    }
    
    (:validate:)
let $schema := doc('/db/apps/OEDUc/schema/tei-epidoc.rng')
            let $validation := validation:jing($item, $schema)
            return 
            if($validation = true()) then (
    (: create the new file with a still-empty id element :)
    let $store := xmldb:store($data-collection, $file, $item)
    
(: update the next-id.xml file :)
let $new-next-id :=  update replace doc($next-id-file-path)/new/id/text() with ($id + 1)


    
    (:confirmation page with instructions for editors:)
    return
        <html>
            
            <head>
                <link
                    rel="shortcut icon"
                    href="/resources/images/favicon.ico"/>
                <meta
                    name="viewport"
                    content="width=device-width, initial-scale=1.0"/>
                <link
                    rel="shortcut icon"
                    href="/resources/images/minilogo.ico"/>
                <link
                    rel="stylesheet"
                    type="text/css"
                    href="$shared/resources/css/bootstrap-3.0.3.min.css"/>
                <link
                    rel="stylesheet"
                    href="/resources/font-awesome-4.7.0/css/font-awesome.min.css"/>
                <link
                    rel="stylesheet"
                    type="text/css"
                    href="/resources/css/style.css"/>
                <script
                    xmlns=""
                    type="text/javascript"
                    src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
                <script
                    xmlns=""
                    type="text/javascript"
                    src="http://code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
                <script
                    xmlns=""
                    type="text/javascript"
                    src="http://cdn.jsdelivr.net/jquery.slick/1.6.0/slick.min.js"></script>
                <script
                    type="text/javascript"
                    src="$shared/resources/scripts/loadsource.js"></script>
                <script
                    type="text/javascript"
                    src="$shared/resources/scripts/bootstrap-3.0.3.min.js"></script>
                
                <title>Save Confirmation</title>
            </head>
            <body>
                <div
                    id="confirmation"><p
                        class="lead">Thank you very much {xmldb:get-current-user()}!</p>
                    <p> Your entry for 
                        <a href="http://betamasaheft.aai.uni-hamburg.de:8080/exist/apps/OEDUc/inscription/{$Newid}" target="_blank"><span
                            class="lead">{$title}</span></a> has been saved!</p>
                   
                    <a
                        href="http://betamasaheft.aai.uni-hamburg.de:8080/exist/apps/OEDUc/newentry.html">Create another entry</a>
                </div>
                
            </body>
        </html>) else (
        
         <html>
            
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
                    type="text/javascript"
                    src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
                <script
                    type="text/javascript"
                    src="$shared/resources/scripts/loadsource.js"></script>           
                    
                   <script
                    type="text/javascript"
                    src="$shared/resources/scripts/bootstrap-3.0.3.min.js"></script>
                 
                   
                <title>Not saved, your file is not valid.</title>
                
            </head>
            <body>
                <div class="col-md-12 alert alert-warning"><div class="col-md-6"><p class="lead">Sorry, the document you are trying to save is not valid. There is probably an error in the content somewhere. Below you can see the report from the schema. Beside the XML, check it out or send the link or a screenshoot to somebody for help.</p>
                <pre>{validation:jing-report($item, $schema)}</pre></div>
                <div class="col-md-6"><div id="editorContainer"><div id="ACEeditor">{$item}</div></div></div>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/ace/1.2.6/ace.js" type="text/javascript" charset="utf-8"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/ace/1.2.6/ext-language_tools.js" type="text/javascript" charset="utf-8"></script>
            </div>   
             <div class="col-md-12"><a  role="button" style="margin-botto:4px; word-wrap:break-word; white-space:normal;" class="col-md-6 btn btn-success" href="/OEDUc/newentry.html?L+text={$leidenplus}&amp;{$chainpars}">back to editor</a></div>
<script src="resources/js/ACEsettings.js"/> 
            </body>
        </html>
        )