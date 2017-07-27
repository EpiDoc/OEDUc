xquery version "3.1" encoding "UTF-8";

module namespace api = "https://www.betamasaheft.uni-hamburg.de/oeduc/api";
import module namespace console = "http://exist-db.org/xquery/console";
import module namespace xqjson="http://xqilla.sourceforge.net/lib/xqjson";
import module namespace kwic = "http://exist-db.org/xquery/kwic"
    at "resource:org/exist/xquery/lib/kwic.xql";
(: For interacting with the TEI document :)
declare namespace t = "http://www.tei-c.org/ns/1.0";
declare namespace dcterms = "http://purl.org/dc/terms";
declare namespace saws = "http://purl.org/saws/ontology";
declare namespace cmd = "http://www.clarin.eu/cmd/";


(: For REST annotations :)
declare namespace rest = "http://exquery.org/ns/restxq";
declare namespace http = "http://exquery.org/ns/restxq";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace json = "http://www.json.org";


declare 
%rest:GET
%rest:path("/BetMas/api/OEDUc/places/{$id}/kml")
%output:method("xml")
function api:kml($id as xs:string*) {
let $item := collection('/db/apps/OEDUc/data/')//id($id)
return 
<rest:response>
            <http:response
                status="200">
                <http:header
                    name="Content-Type"
                    value="application/xml; charset=utf-8"/>
            </http:response>
        </rest:response>,
       
       <kml>
       {for $inscription in collection('/db/apps/OEDUc/data/')
       return 
       <Placemark>
        <address>{$inscription//t:origPlace/t:placeName[not(@type)]/text()}</address>
        <description/>
        <name>{$inscription//t:title/text()}</name>
        <Point>
            <coordinates>9.177017,48.782326,0</coordinates>
        </Point>
        <TimeStamp>
            <when>{string(max(xs:date($inscription//t:change/@when)))}</when>
        </TimeStamp>
    </Placemark>
       }
       </kml>
};


(:a test export of pelagios annotations. not suitable for the complete data set, but parametrizable to filter a more reasonable dataset.:)
declare 
%rest:GET
%rest:path("/BetMas/api/OEDUc/places/all")
%output:method("text")
function api:placesttl() {
let $data := subsequence(collection('/db/apps/OEDUc/data/'), 1, 20)
let $test := console:log($data)
return
(<rest:response>
            <http:response
                status="200">
                <http:header
                    name="Content-Type"
                    value="text; charset=utf-8"/>
            </http:response>
        </rest:response>, '
        @prefix cnt: &lt;http://www.w3.org/2011/content#&gt; . 
        @prefix dcterms: &lt;http://purl.org/dc/terms/&gt; .
        @prefix foaf: &lt;http://xmlns.com/foaf/0.1/&gt; .
        @prefix oa: &lt;http://www.w3.org/ns/oa#&gt; .
        @prefix pelagios: &lt;http://pelagios.github.io/vocab/terms#&gt; .
        @prefix relations: &lt;http://pelagios.github.io/vocab/relations#&gt; .
        @prefix xsd: &lt;http://www.w3.org/2001/XMLSchema&gt; .',
for $d in $data return transform:transform($d, 'xmldb:exist:///db/apps/OEDUc/xslt/pelagios.xsl', ()))
};

declare 
%rest:GET
%rest:path("/BetMas/api/OEDUc/places/all/void")
%output:method("text")
function api:voidttl() {
<rest:response>
            <http:response
                status="200">
                <http:header
                    name="Content-Type"
                    value="text; charset=utf-8"/>
            </http:response>
        </rest:response>, 
        '
@prefix : &lt;http://betamasaheft.aai.uni-hamburg.de:8080/exist/apps/OEDUc&gt; .
        @prefix void: &lt;http://rdfs.org/ns/void#&gt; .
        @prefix dcterms: &lt;http://purl.org/dc/terms/&gt; .
        @prefix foaf: &lt;http://xmlns.com/foaf/0.1/&gt; .
        
        :"test rest like call to generate void dataset" a void:Dataset;
        dcterms:title "Open Epigraphic Data Unconference";
        dcterms:publisher "Open Epigraphic Data Unconference";
        foaf:homepage &lt;http://betamasaheft.aai.uni-hamburg.de:8080/exist/apps/OEDUc/index.html&gt;;
        dcterms:description "a test app bringing together resources from the workshop held on 15 May 2017 in London";
        dcterms:license &lt;http://opendatacommons.org/licenses/odbl/1.0/&gt;;
        void:dataDump &lt;http://betamasaheft.aai.uni-hamburg.de/api/OEDUc/places/all&gt; ;
        .'};