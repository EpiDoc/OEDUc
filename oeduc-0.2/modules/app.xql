xquery version "3.1";

module namespace app="http://oeduc.eu/templates";

declare namespace t = "http://www.tei-c.org/ns/1.0";
declare namespace skos = "http://www.w3.org/2004/02/skos/core#";
declare namespace rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace s = "http://www.w3.org/2005/xpath-functions";
declare namespace sparql = "http://www.w3.org/2005/sparql-results#";

import module namespace kwic = "http://exist-db.org/xquery/kwic"
    at "resource:org/exist/xquery/lib/kwic.xql";
import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://oeduc.eu/config" at "config.xqm";
import module namespace console="http://exist-db.org/xquery/console";
import module namespace xdb = "http://exist-db.org/xquery/xmldb";
import module namespace httpclient="http://exist-db.org/xquery/httpclient";
import module namespace validation = "http://exist-db.org/xquery/validation";

declare variable $app:id := request:get-parameter('id', ()) ;

(:on login, print the name of the logged user:)
declare function app:greetings($node as element(), $model as map(*)) as xs:string{
<a href="">Hi {xmldb:get-current-user()}!</a>
    };

(:adds the new entry button:)
 declare function app:newentry($node as element(), $model as map(*)) {
<a role="button" class="btn btn-info" href="/exist/apps/OEDUc/newentry.html">
                   New Entry
                </a>
};  


(:in case a query is entered, keeps the value entered in the input box:)
declare function app:queryinput ($node as node(), $model as map(*), $q as xs:string*){<input name="q" type="search" class="form-control" placeholder="Search string" value="{$q}"/>};


(:query to return all the resources/ files in the XML database, passes them on in a map to the functions app:hit-count, app:paginate and app:listRes, as they are called in list.html:)
declare %templates:wrap function app:list($node as element(), $model as map(*)) {
let $hits := for $hit in collection($config:data-root) return $hit
return 
  map {
                    "hits" := $hits
                }
};  


(:this function is used in the index page when you enter a word in the search box:)
declare %templates:wrap
    %templates:default("mode", "none")
function app:query($node as node()*, $model as map(*), $q as xs:string?){
if($q) then 
let $options :=
    <options>
        <default-operator>or</default-operator>
        <phrase-slop>0</phrase-slop>
        <leading-wildcard>yes</leading-wildcard>
        <filter-rewrite>yes</filter-rewrite>
    </options>
let $data-collection := '/db/apps/OEDUc/data'
let $hits := for $hit in collection($data-collection)//t:ab[ft:query(., $q)] order by ft:score($hit) descending return $hit
return
  map {"hits" := $hits}
  else ()
};




(:defines how results are printed in the list view :)
declare    
%templates:wrap
    %templates:default('start', 1)
    %templates:default("per-page", 10) 
    function app:listRes (
    $node as node(), 
    $model as map(*), $start as xs:integer, $per-page as xs:integer) {
        
    for $text at $p in subsequence($model("hits"), $start, $per-page)
    let $x := $text//t:TEI
    let $id := $x//t:text/@xml:id
return
<div class="row">
<div class="col-md-3"><a href="/exist/apps/OEDUc/inscription/{$id}">{$x//t:title/text()}</a>  </div>
<div class="col-md-3"><a role="button" class="btn btn-success btn-xs" href="/exist/apps/OEDUc/update.html?id={$id}&amp;new=false">update</a></div>
<div class="col-md-3"><a role="button" class="btn btn-warning btn-xs" href="/exist/apps/OEDUc/edit/delete-confirm.xq?id={$id}">delete</a></div>
<div class="col-md-3"><a href="/exist{concat(substring-after(base-uri($x), '/db'),'/', $id,'.xml')}" role="button" class="btn btn-info btn-xs" >XML</a></div>
</div>

};

(:defines how results are printed in the search results list. Note that there is a library Kwic which prints instead of the simple hit a keyword in context view.:)
declare    
%templates:wrap
    %templates:default('start', 1)
    %templates:default("per-page", 10) 
    function app:searchRes (
    $node as node(), 
    $model as map(*), $start as xs:integer, $per-page as xs:integer) {
        
    for $term at $p in subsequence($model("hits"), $start, $per-page)
        let $id := root($term)//t:text/@xml:id
              let $term-name := root($term)//t:title/text()
              order by ft:score($term) descending
             
          return
            <div class="row reference ">
               <div class="col-md-4"><a href="/exist/apps/OEDUc/inscription/{data($id)}">{$term-name}</a></div>
               <div class="col-md-4">{kwic:summarize($term,<config width="40"/>)}</div>
               <div class="col-md-4"><code>{$term/name()}</code></div>
            </div>
        };


(:counts hits of a query in app:list and prints the result. This at the moment will always be the total because the query does not take any parameter:)
declare 
    %templates:wrap function app:hit-count($node as node()*, $model as map(*)) {
    <h3>There are <span xmlns="http://www.w3.org/1999/xhtml" id="hit-count">{ count($model("hits")) }</span> entries!</h3>
    
};


(:produces the form to update an inscription text and metadata, by grabbing the content and converting it to the 
relevant input and textarea elements. the elements where the search is performed are defined in collection.xconf, 
which is usually placed in the collection system parallel to db.:)

declare function app:update ($node as node()*, $model as map(*)) {
let $new := request:get-parameter('new', '')
let $id := request:get-parameter('id', '')
let $data-collection := '/db/apps/OEDUc/data/'
let $file := if ($new='true') then 
        'new-instance.xml'
    else 
        collection($data-collection)//id($id)
let $title := root($file)//t:title/text()
(:this will match tei:entry:)

return
 (
 <div class="col-md-12">
 <h2>Edit Inscription {$title}</h2>
            <a id="underdot" class="btn btn-primary">underdot</a>
            <a id="abbreviation" class="btn btn-primary">abbreviation</a>
            <a id="choice" class="btn btn-primary">choice</a>
            <a id="linebreak" class="btn btn-primary">linebreak</a>
            <a id="supplied" class="btn btn-primary">supplied</a> 
            <a id="omitted" class="btn btn-primary">omitted</a> 
            <a id="deleted" class="btn btn-primary">deleted</a> 
            <a id="gap" class="btn btn-primary">gap</a>
        </div>,
(:        the text is here transformed with an XSLT to the leiden+ like synthax, then form groups are created for each metadata field with a reference to the EAGLE vocabulary. There a list of values is produced where the one currently used is preselected.:)
                <form id="updateEntry" action="" >
                <div class="form-group">
                <input hidden="hidden" value="{$id}" name="id"/>
                
            <div class="col-md-10">
                <textarea class="form-control" id="L+text" name="L+text" required="required" style="height:250px;">{transform:transform($file//t:ab, 'xmldb:exist:///db/apps/OEDUc/xslt/xml2editor.xsl', ())}</textarea>
                
            <button id="confirmcreatenew" type="submit" class="btn btn-primary">update entry</button>
            </div> 
        </div>
     
       <div class="form-group">
                <select class="form-control" name="material">
                {for $material in doc('/db/apps/OEDUc/EAGLEvoc/eagle-vocabulary-material.rdf')//skos:Concept
                return
                <optgroup label="{$material//skos:prefLabel}">
                {for $label in ($material//skos:prefLabel, $material//skos:altLabel)
                return 
                element option { 
                                attribute value {$material/@rdf:about},
                                if($label/name() = 'skos:prefLabel' and root($file)//t:material/@ref = $material/@rdf:about) then (attribute selected {'selected'}) else (),
                                
                                $label
                }
                }
                </optgroup>}
                
                </select>
                </div>
                <div class="form-group">
                <select class="form-control" name="objectType">
                {for $concept in doc('/db/apps/OEDUc/EAGLEvoc/eagle-vocabulary-object-type.rdf')//skos:Concept
                return
                <optgroup label="{$concept//skos:prefLabel}">
                {for $label in ($concept//skos:prefLabel, $concept//skos:altLabel)
                return 
                element option { 
                                attribute value {$concept/@rdf:about},
                                if($label/name() = 'skos:prefLabel' and root($file)//t:objectType/@ref = $concept/@rdf:about) then (attribute selected {'selected'}) else (),
                                
                                $label
                }
                }
                </optgroup>}
                
                </select>
                </div>
                <div class="form-group">
                <select class="form-control" name="decoration">
                {for $concept in doc('/db/apps/OEDUc/EAGLEvoc/eagle-vocabulary-decoration.rdf')//skos:Concept
                return
                <optgroup label="{$concept//skos:prefLabel}">
                {for $label in ($concept//skos:prefLabel, $concept//skos:altLabel)
                return 
                element option { 
                                attribute value {$concept/@rdf:about},
                                if($label/name() = 'skos:prefLabel' and root($file)//t:rs[@type='decoration']/@ref = $concept/@rdf:about) then (attribute selected {'selected'}) else (),
                                
                                $label
                }
                }
                </optgroup>}
                
                </select>
                </div>
                
                <div class="form-group">
                <select class="form-control" name="type-of-inscription">
                {for $concept in doc('/db/apps/OEDUc/EAGLEvoc/eagle-vocabulary-type-of-inscription.rdf')//skos:Concept
                return
                <optgroup label="{$concept//skos:prefLabel}">
                {for $label in ($concept//skos:prefLabel, $concept//skos:altLabel)
                return 
                element option { 
                                attribute value {$concept/@rdf:about},
                                if($label/name() = 'skos:prefLabel' and root($file)//t:term/@ref = $concept/@rdf:about) then (attribute selected {'selected'}) else (),
                                
                                $label
                }
                }
                </optgroup>}
                
                </select>
                </div>
                <div class="form-group">
                <select class="form-control" name="writing">
                {for $concept in doc('/db/apps/OEDUc/EAGLEvoc/eagle-vocabulary-writing.rdf')//skos:Concept
                return
                <optgroup label="{$concept//skos:prefLabel}">
                {for $label in ($concept//skos:prefLabel, $concept//skos:altLabel)
                return 
                element option { 
                                attribute value {$concept/@rdf:about},
                                if($label/name() = 'skos:prefLabel' and root($file)//t:rs[@type='execution']/@ref = $concept/@rdf:about) then (attribute selected {'selected'}) else (),
                                
                                $label
                }
                }
                </optgroup>}
                
                </select>
                </div>
                </form>,
                <p><a href="http://papyri.info/docs/leiden_plus">Leiden+ Guidelines</a></p>)
};

(:takes the input of the form and actually does the update:)

declare function app:DoUpdate($node as node()*, $model as map(*)){
let $newText := request:get-parameter('L+text', ())

return
if($newText) then (

let $id := request:get-parameter('id', ())
let $material := request:get-parameter('material', ())
let $writing := request:get-parameter('writing', ())
let $objectType := request:get-parameter('objectType', ())
let $typeIns := request:get-parameter('type-of-inscription', ())
let $data-collection := '/db/apps/OEDUc/data'
let $title := 'Update Confirmation'
let $data-collection := '/db/apps/OEDUc/data'
 let $targetfileuri := base-uri(collection($data-collection)//id($id))
let $d := doc($data-collection ||'/' || $id || '.xml')
let $testD := console:log($d)
let $testD1 := console:log($targetfileuri)
(:takes the string and parses it to transform into xml again:)
let $transForm := transform:transform(<node>{$newText}</node>, 'xmldb:exist:///db/apps/OEDUc/xslt/upconversion.xsl', ())


let $updateform :=  update replace $d//t:ab with $transForm

let $updatematerial := 
if( $d//t:material[@ref]) 
then update value $d//t:material/@ref with $material 
else (update insert attribute ref {$material} into $d//t:material)

let $updatewriting :=  
if( $d//t:rs[@type='execution'][@ref]) 
then update value $d//t:rs[@type='execution']/@ref with $writing 
else (update insert attribute ref {$writing} into $d//t:rs[@type='execution'])
let $updateobjectType :=  
if( $d//t:objectType[@ref]) 
then update value $d//t:objectType/@ref with $objectType 
else (update insert attribute ref {$objectType} into $d//t:objectType)
let $updatetypeIns :=  
if( $d//t:term[@ref]) 
then update value $d//t:term/@ref with $typeIns 
else (update insert attribute ref {$typeIns} into $d//t:term)
         
        
return

(:the following is just a report after the updates have been made, deciding on the basis of a validation report what to print:)
<div class="col-md-4">
    <h1>{$title}</h1>
    <p>Item {$id} has been updated.</p>
    <a href="../OEDUc/inscription/{$id}">{$id}</a>
    <div class="col-md-12">Validation report agains EpiDoc schema says:
    {let $schema := doc('/db/apps/OEDUc/schema/tei-epidoc.rng')
            let $validation := validation:jing-report($d//t:TEI, $schema)
            let $test :=console:log($validation)
            let $color := if($validation//status = 'invalid') then 'alert alert-warning' else 'alert alert-success'
            return 
            <div>{attribute class {$color}}<p class="lead">{$validation//status}</p></div>}
    </div>
  </div>) 
  
  else ()
};


(:The parameters which will change the way the text is displayed this will be taken from the app showing the text and used in the call to the EpiDoc xslt:)
declare function app:parameters($node as node()*, $model as map(*)){
<div class="col-md-12">
<form>
<div class="input-group">
<select class="form-control" name="leiden-style">
    <option value="ddbdp">ddbdp</option>
    <option value="dohnicht">dohnicht</option>
    <option value="edh-itx">edh-itx</option>
    <option value="edh-names">edh-names</option>
    <option value="edh-web">edh-web</option> 
    <option value="ila">ila</option>
    <option value="iospe">iospe</option>
    <option value="london">london</option>
    <option value="panciera" selected="selected">panciera</option>
    <option value="petrae">petrae</option>
    <option value="rib">rib</option>
    <option value="seg">seg</option>
    <option value="sammelbuch">sammelbuch</option>
    <option value="eagletxt">eagletxt</option>
  </select>
  </div>
  
<div class="input-group">
  <select class="form-control" name="edn-structure">
    <option value="default" selected="selected">default</option>
    <option value="ddbdp">ddbdp</option>
    <option value="hgv">hgv</option>
    <option value="inslib">inslib</option>
    <option value="iospe">iospe</option>
    <option value="edh">edh</option>
    <option value="edh-db">edh-db</option>
    <option value="rib">rib</option>
    <option value="sammelbuch">sammelbuch</option>
    <option value="eagle">eagle</option>
    <option value="igcyr">igcyr</option>
  </select>
  
  </div>
  
<div class="input-group">
  <select class="form-control" name="edition-type">
    <option value="interpretive" selected="selected">interpretive</option>
    <option value="diplomatic">diplomatic</option>
  </select>
  
  </div>
  
<div class="input-group">
  <select class="form-control" name="internal-app-style">
    <option value="none" selected="selected">none</option>
    <option value="ddbdp">ddbdp</option><!-- NB: change this select locally if you're running PN or SoSOL process! -->
    <option value="iospe">iospe</option>
    <option value="fullex">fullex</option> <!--this example uses all the currently specified internal apparatus features-->
<option value="minex">minex</option> <!--this is the same as above but only uses some common examples-->
  </select>
  
  </div>
  
<div class="input-group">
  <select class="form-control" name="external-app-style">
    <option value="default" selected="selected">default</option>
    <option value="iospe">iospe</option>
  </select>
  
  </div>
  
<div class="input-group">
  <select class="form-control" name="line-inc">
    <option value="5" selected="selected">5</option>
    <option value="10">10</option>
    <option value="4">4</option>
    <option value="8">8</option>
  </select>
  

        
     
  </div>
  <button class="btn btn-secondary" type="submit">change</button>
 </form>
</div>
        
};


(:prints the metadata taking them from the XML file:)

declare %templates:wrap function app:metadata($node as node()*, $model as map(*)){
let $file := $model('file')
let $r := root($file)
(:the first table makes a http request to the ids service in Hamburg which returns results in this format

<tmid id="202331">
<link cp="EDCS">06000002</link>
<link cp="EDH">HD059005</link>
<link cp="IRT">IRT003</link>
</tmid>


which is eventually the format required by EAGLE for disambiguation.

also other formats are available and other types of query:

diese query gibt alle verfügbare ids für einen Inschrift.
http://betamasaheft.aai.uni-hamburg.de/api/eagle/290111

das nimmt ein parameter source mit Wert tm (default wie oben), edh, edr, edcs, he oder edb

http://betamasaheft.aai.uni-hamburg.de/api/eagle/HD059005?source=edh 
oder 
http://betamasaheft.aai.uni-hamburg.de/api/eagle/06000002?source=edcs
sollten die gleiche Ergebnis geben. 

in XML statt JSON mit /xml/ wie in folgende Beispiel.

http://betamasaheft.aai.uni-hamburg.de/api/eagle/xml/EDR078902?source=edr

Ganze liste sind auch verfügbar (mit Geduld...)
http://betamasaheft.aai.uni-hamburg.de/api/eagleids
http://betamasaheft.aai.uni-hamburg.de/api/eagleids/xml

man kann hier ein parameter start benutzen. es gibt 100 Ergebnisse für jede Anruf. 

Trotzdem EDCS hat 491518 TMids, und es gibt 494740 verschiedene. Die kann mann in gruppe von 1000 abrufen
http://betamasaheft.aai.uni-hamburg.de/api/eagle/ALLTMids


Hier stehen die Ergebnisse in JSON mit URIs statt IDs:
http://betamasaheft.aai.uni-hamburg.de/api/eagleids/uris
http://betamasaheft.aai.uni-hamburg.de/api/eagle/uri/122176
http://betamasaheft.aai.uni-hamburg.de/api/eagle/uri/EDR078902?source=edr
:)
return
<div class="col-md-12">
<table class="table table-responsive  table-hover">
<thead>
<tr><th>DB</th><th>id</th></tr>
</thead>

<tbody>{
let $edh := string($model('file')/@xml:id)
let $query := 'http://betamasaheft.aai.uni-hamburg.de/api/eagle/xml/' || $edh||'?source=edh'
let $req := httpclient:get(xs:anyURI($query), false(), <headers/>)
return
(<tr><td>TM</td><td>{if(contains($req//tmid/@id, ' ')) then for $tm in tokenize(string($req//tmid/@id), ' ') return <a href="http://www.trismegistos.org/text/{$tm}">{$tm || ' '} </a> else <a href="http://www.trismegistos.org/text/{string($req//tmid/@id)}">{string($req//tmid/@id)}</a>}</td></tr>,
for $id in  $req//link
return
<tr><td>{string($id/@cp)}</td><td><a class="{$id/@cp}">{attribute href {switch($id/@cp) case 'EDCS' return 'http://db.edcs.eu/epigr/edcs_id_en.php?p_edcs_id=EDCS-' || $id
case 'EDH' return 'http://edh-www.adw.uni-heidelberg.de/edh/inschrift/' || $id
case 'EDR' return 'http://www.edr-edr.it/edr_programmi/res_complex_comune.php?do=book&amp;id_nr=' || $id
case 'EDB' return 'http://www.edb.uniba.it/epigraph/' || $id
case 'RIB' return 'romaninscriptionsofbritain.org/rib/inscriptions/' || $id
case 'IRT' return 'http://inslib.kcl.ac.uk/irt2009/' || $id
case 'LUPA' return 'http://www.ubi-erat-lupa.org/monument.php?id=' || $id
case 'LSA' return 'http://laststatues.classics.ox.ac.uk/database/detail.php?record=' || $id
case 'HE' return 'http://eda-bea.es/pub/record_card_1.php?rec=' || $id
default return $id}, string($id)}</a></td></tr>

)
}
</tbody>
</table>
<table class="table table-responsive  table-hover">
{for $metadata in $r//t:*[@ref]
(:this table instead calls another app:wikitable where a http request to the wikidata SPARQL endpooint is made:)
return
if ($metadata/name() = 'placeName') then
<tr><td>{$metadata/name()} {if($metadata/@type) then ', ' || string($metadata/@type) else ()}</td><td><a href="{$metadata/@ref}">{$metadata}</a>
<table><thead><tr><th>name</th><th>value</th></tr></thead>{let $tmid := $metadata return app:wikitable($tmid)}</table>
</td></tr>
else
<tr><th>{$metadata/name()} {if($metadata/@type) then ', ' || string($metadata/@type) else ()}</th><th><a href="{$metadata/@ref}">{$metadata}</a></th></tr>

}
</table>
<div class="col-md-8"></div>
</div>

};


(:this function makes a call to wikidata SPARQL based on the tm id in a placeName/@ref in order to return the corresponding pleiades id.:)
declare function app:wikitable($tmid) {

let $bareTM := substring-after(string($tmid/@ref), 'http://www.trismegistos.org/place/')
let $sparql := 'SELECT ?item ?itemLabel ?pleiades ?coord WHERE {
   ?item wdt:P1958 "' ||$bareTM|| '" .
   ?item wdt:P1584 ?pleiades .
   ?item wdt:P625 ?coord . 
   SERVICE wikibase:label {
    bd:serviceParam wikibase:language "en" .
   }
 }'
(: 

return the item name, the item label, the pleiades property value and the coordinates property value.
where the item as a property Trismegistos Geo ID = to the current TM geo ID and has pleiades id and coord. (i.e. if one of the two is not there, the item will not be considered!.)

https://www.wikidata.org/wiki/Wikidata:SPARQL_query_service/queries
https://query.wikidata.org

https://www.wikidata.org/wiki/Property:P1958 Trismegistos GEO ID
https://www.wikidata.org/wiki/Property:P1584 Pleiades ID
https://www.wikidata.org/wiki/Property:P625 Coordinates
:)

let $query := 'https://query.wikidata.org/sparql?query='|| xmldb:encode-uri($sparql)
let $req := httpclient:get(xs:anyURI($query), false(), <headers/>)

(:returns the result in another small table with links:)
return
(<tr><td>TM Geo ID</td><td><a class="tm" href="http://www.trismegistos.org/place/{$bareTM}">{$bareTM}</a></td></tr>,
for $x in $req//sparql:result/sparql:binding[not(@name="itemLabel")] 
return <tr><td>{
switch($x/@name) 
case 'item' return 'wikidata item' 
case 'pleiades' return 'pleiades' 
case 'coord' return 'coordinates' 
default return 'item name'}</td>
<td>{switch($x/@name) case 'item' 
return <a class="wd" href="{$x}">{$req//sparql:result/sparql:binding[@name="itemLabel"]}</a>
case 'pleiades' return <a class="pleiades" href="https://pleiades.stoa.org/places/{$x}">{$x}</a>
case 'coord' return <span class="coord">{$x}</span>
default return ''}</td>
</tr>)

};


(:for the item view, this finds the desired resource and passes on the tree as a map to other functions:)

declare 
%templates:wrap function app:Theitem($node as node()*, $model as map(*), $id as xs:string?){
let $col := collection('/db/apps/OEDUc/data')
let $id := request:get-parameter('id', ())
let $file := $col//id($id)

return map{'file' := $file}

};



(:this function shows the contents of the EpiDoc TEI file. The parameters from the form are used to pass parameters to the EpiDoc stylesheets. this is called by item.html in the templating systen, where also a script is called to interact with the EDH api.:)
declare
%templates:wrap
%templates:default("leiden-style", "panciera")
%templates:default("edn-structure", "default")
%templates:default("line-inc", "5")
%templates:default("edition-type", "interpretive")
%templates:default("internal-app-style", "none")
%templates:default("external-app-style", "default")
function app:item(
$node as node()*, 
$model as map(*), 
$id as xs:string?,
$leiden-style as xs:string,
$edn-structure as xs:string,
$line-inc as xs:double,
$edition-type as xs:string,
$internal-app-style as xs:string,
$external-app-style as xs:string){
 
let $file := $model('file')
let $insc:= $file//t:div[@type='edition']
let $params := <parameters>
    <param name="internal-app-style" value="{$internal-app-style}"/>
    <param name="external-app-style" value="{$external-app-style}"/>
    <param name="edn-structure" value="{$edn-structure}"/>
    <param name="edition-type" value="{$edition-type}"/>
    <param name="leiden-style" value="{$leiden-style}"/>
    <param name="line-inc" value="{$line-inc}"/>
</parameters>
return
(:the function points the current file to a driver file in the EpiDoc example XSLT, taking the values entered in the form, the starttext mode is selected, as the metadata and template are generated in the app. more parameters could be added:)
(transform:transform($insc, 'xmldb:exist:///db/apps/OEDUc/EpiDocXslt/oeductext.xsl',$params),

<div class="col-md-12 btn-group">
        <a role="button" class="btn btn-info" href="/exist/apps/OEDUc/update.html?id={$app:id}&amp;new=false">Update</a>
        <a role="button" class="btn btn-danger" href="/exist/apps/OEDUc/edit/delete-confirm.xq?id={$app:id}">Delete</a>
        <a href="/exist{concat(substring-after(base-uri($file), '/db'),'/', $app:id,'.xml')}" role="button" class="btn btn-success" >XML</a>
        </div>)

};


(: a wonderfull function copied from the shakespeare demo app of exist-db to provide pagination for the results of a query:)
declare
    %templates:wrap
    %templates:default('start', 1)
    %templates:default("per-page", 20)
    %templates:default("min-hits", 0)
    %templates:default("max-pages", 20)
function app:paginate($node as node(), $model as map(*), $start as xs:int, $per-page as xs:int, $min-hits as xs:int,
    $max-pages as xs:int) {
        
    if ($min-hits < 0 or count($model("hits")) >= $min-hits) then
        let $count := xs:integer(ceiling(count($model("hits"))) div $per-page) + 1
        let $middle := ($max-pages + 1) idiv 2
        let $params :=
                string-join(
                    for $param in request:get-parameter-names()
                    for $value in request:get-parameter($param, ())
                    return
                    if ($param = 'collection') then ()
                    else if ($param = 'start') then ()
                    else
                        $param || "=" || $value,
                    "&amp;"
                )
        return (
            if ($start = 1) then (
                <li class="disabled">
                    <a><i class="glyphicon glyphicon-fast-backward"/></a>
                </li>,
                <li class="disabled">
                    <a><i class="glyphicon glyphicon-backward"/></a>
                </li>
            ) else (
                <li>
                    <a href="?{$params}&amp;start=1"><i class="glyphicon glyphicon-fast-backward"/></a>
                </li>,
                <li>
                    <a href="?{$params}&amp;start={max( ($start - $per-page, 1 ) ) }"><i class="glyphicon glyphicon-backward"/></a>
                </li>
            ),
            let $startPage := xs:integer(ceiling($start div $per-page))
            let $lowerBound := max(($startPage - ($max-pages idiv 2), 1))
            let $upperBound := min(($lowerBound + $max-pages - 1, $count))
            let $lowerBound := max(($upperBound - $max-pages + 1, 1))
            for $i in $lowerBound to $upperBound
            return
                if ($i = ceiling($start div $per-page)) then
                    <li class="active"><a href="?{$params}&amp;start={max( (($i - 1) * $per-page + 1, 1) )}">{$i}</a></li>
                else
                    <li><a href="?{$params}&amp;start={max( (($i - 1) * $per-page + 1, 1)) }">{$i}</a></li>,
            if ($start + $per-page < count($model("hits"))) then (
                <li>
                    <a href="?{$params}&amp;start={$start + $per-page}"><i class="glyphicon glyphicon-forward"/></a>
                </li>,
                <li>
                    <a href="?{$params}&amp;start={max( (($count - 1) * $per-page + 1, 1))}"><i class="glyphicon glyphicon-fast-forward"/></a>
                </li>
            ) else (
                <li class="disabled">
                    <a><i class="glyphicon glyphicon-forward"/></a>
                </li>,
                <li>
                    <a><i class="glyphicon glyphicon-fast-forward"/></a>
                </li>
            )
        ) else
            ()
};


