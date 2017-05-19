<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: global-varsandparams.xsl 2476 2016-10-10 15:05:02Z pietroliuzzo $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

            <!-- Location of file defining the parameters and variables -->
            <xsl:variable name="param-file">
                        <xsl:text>global-parameters.xml</xsl:text>
            </xsl:variable>

            <!-- Location of HGV glossary file relative to the current file -->
            <xsl:param name="hgv-gloss">
                        <xsl:text>../../../xml/idp.data/trunk/HGV_trans_EpiDoc/glossary.xml</xsl:text>
            </xsl:param>

            <!-- Mapping file -->
            <xsl:variable name="mapping-file" select="'../crosswalker/aggregator/mapping/mapping.xml'"/>

<!--            <xsl:param name="topNav" select="document($param-file)//parameter[name = 'topNav']/value[@on = 'yes']"/>-->
<!--            <xsl:param name="verse-lines" select="document($param-file)//parameter[name = 'verse-lines']/value[@on = 'yes']"/>-->
            <xsl:param name="leiden-style"/>
            <xsl:param name="edn-structure"/>
            <xsl:param name="edition-type"/>
            <xsl:param name="internal-app-style"/>
            <xsl:param name="external-app-style"/>
            <xsl:param name="line-inc"/>
            <!--<xsl:param name="css-loc" select="document($param-file)//parameter[name = 'css-loc']/value"/>
            <xsl:param name="js-dir" select="document($param-file)//parameter[name = 'js-dir']/value"/>
            <xsl:param name="bibliography" select="document($param-file)//parameter[name = 'bibliography']/value[@on = 'yes']"/>
            <xsl:param name="localbibl" select="document($param-file)//parameter[name = 'localbibl']/value"/>
            <xsl:param name="ZoteroUorG" select="document($param-file)//parameter[name = 'ZoteroUorG']/value[@on = 'yes']"/>
            <xsl:param name="ZoteroKey" select="document($param-file)//parameter[name = 'ZoteroKey']/value[@on = 'yes']"/>
            <xsl:param name="ZoteroNS" select="document($param-file)//parameter[name = 'ZoteroNS']/value[@on='yes']"/>
            <xsl:param name="ZoteroStyle" select="document($param-file)//parameter[name = 'ZoteroStyle']/value[@on = 'yes']"/>
    -->
            <xsl:param name="docroot">../output/data</xsl:param>

            <xsl:variable name="all-grc">
                        <xsl:text>abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZἀἁἂἃἄἅἆἇἈἉἊἋἌἍἎἏΑὰάᾀᾁᾂᾃᾄᾅᾆᾇᾈᾉᾊᾋᾌᾍᾎᾏᾲᾳᾴᾶᾷάέΕἐἑἒἓἔἕἘἙἚἛἜἝὲέΗήἠἡἢἣἤἥἦἧἨἩἪἫἬἭἮἯᾐᾑᾒᾓᾔᾕᾖᾗᾘᾙᾚᾛᾜᾝᾞᾟῂῃῄῆῇὴήΙίϊἰἱἲἳἴἵἶἷἸἹἺἻἼἽἾἿὶίῒΐΐῖῗΟόὀὁὂὃὄὅὈὉὊὋὌὍὸό΅ύὐὑὒὓὔὕὖὗὙὛὝὟὺύῢΰΰῦῧϋΩώὠὡὢὣὤὥὦὧὨὩὪὫὬὭὮὯὼώᾠᾡᾢᾣᾤᾥᾦᾧᾨᾩᾪᾫᾬᾭᾮᾯῲῳῴῶῷςῤῥαβγδεζηθικλμνξοπρστυφχψωῬΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ</xsl:text>
                        <!--<xsl:text>abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZἀἁἂἃἄἅἆἇἈἉἊἋἌἍἎἏΑὰάᾀᾁᾂᾃᾄᾅᾆᾇᾈᾉᾊᾋᾌᾍᾎᾏᾲᾳᾴᾶᾷάέΕἐἑἒἓἔἕἘἙἚἛἜἝὲέΗήἠἡἢἣἤἥἦἧἨἩἪἫἬἭἮἯᾐᾑᾒᾓᾔᾕᾖᾗᾘᾙᾚᾛᾜᾝᾞᾟῂῃῄῆῇὴήΙίϊἰἱἲἳἴἵἶἷἸἹἺἻἼἽἾἿὶίῒΐΐῖῗΟόὀὁὂὃὄὅὈὉὊὋὌὍὸό΅ύὐὑὒὓὔὕὖὗὙὛὝὟὺύῢΰ7#X03B0;ῦῧϋΩώὠὡὢὣὤὥὦὧὨὩὪὫὬὭὮὯὼώᾠᾡᾢᾣᾤᾥᾦᾧᾨᾩᾪᾫᾬᾭᾮᾯῲῳῴῶῷςῤῥαβγδεζηθικλμνξοπρστυφχψωῬΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ</xsl:text>-->
            </xsl:variable>

            <xsl:variable name="grc-upper-strip">
                        <xsl:text>ABCDEFGHIJKLMNOPQRSTVVWXYZABCDEFGHIJKLMNOPQRSTVVWXYZΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΕΕΕΕΕΕΕΕΕΕΕΕΕΕΕΕΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΟΟΟΟΟΟΟΟΟΟΟΟΟΟΟΟΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΣΡΡΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩΡΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ</xsl:text>
                        <!--<xsl:text>ABCDEFGHIJKLMNOPQRSTVVWXYZABCDEFGHIJKLMNOPQRSTVVWXYZΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΕΕΕΕΕΕΕΕΕΕΕΕΕΕΕΕΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΟΟΟΟΟΟΟΟΟΟΟΟΟΟΟΟΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΣΡΡΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩΡΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ</xsl:text>-->
            </xsl:variable>

            <xsl:variable name="grc-lower-strip">
                        <xsl:text>abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzαααααααααααααααααααααααααααααααααααααααααεεεεεεεεεεεεεεεεηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηιιιιιιιιιιιιιιιιιιιιιιιιιιοοοοοοοοοοοοοοοουυυυυυυυυυυυυυυυυυυυυυωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωσρραβγδεζηθικλμνξοπρστυφχψωραβγδεζηθικλμνξοπρστυφχψω</xsl:text>
                        <!--<xsl:text>abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzαααααααααααααααααααααααααααααααααααααααααεεεεεεεεεεεεεεεεηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηηιιιιιιιιιιιιιιιιιιιιιιιιιιοοοοοοοοοοοοοοοουυυυυυυυυυυυυυυυυυυυυυωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωωσρραβγδεζηθικλμνξοπρστυφχψωραβγδεζηθικλμνξοπρστυφχψω</xsl:text>-->
            </xsl:variable>

</xsl:stylesheet>