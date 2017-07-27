<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
    
<!--    <D=.r<= 
        1. line of text 
        2. line of text 
        =>=D> 
        <D=.v<= 
            3. line of text 
            4. line of text 
            =>=D> -->
            
    <xsl:template match="/">
        <xsl:analyze-string regex="(&lt;D=)(\.([\w\d]{{1,3}}))?(\.(\w+))?(.*)(=D&gt;)" select="normalize-space(.)" flags="s">
            <xsl:matching-substring>
                <xsl:variable name="all" select="regex-group(6)"/>
                <div type="textpart">
                    <xsl:if test="regex-group(2)">
                        <xsl:attribute name="n">
                            <xsl:value-of select="regex-group(3)"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="regex-group(4)">
                        <xsl:attribute name="subtype">
                            <xsl:value-of select="regex-group(5)"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="textparts">
                        <xsl:with-param name="textparts" select="$all"/>
                    </xsl:call-template>
                </div>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:variable name="all" select="."/>
                <xsl:call-template name="ab">
                    <xsl:with-param name="text" select="$all"/>
                </xsl:call-template>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    
    <xsl:template name="textparts">
        <xsl:param name="textparts"/>
        <xsl:analyze-string regex="(&lt;D=)(\.([\w\d]{{1,3}}))?(\.(\w+))?(.*)(=D&gt;)" select="normalize-space($textparts)" flags="s">
            <xsl:matching-substring>
                <xsl:variable name="all" select="regex-group(6)"/>
                <div type="textpart">
                    <xsl:if test="regex-group(2)">
                        <xsl:attribute name="n">
                            <xsl:value-of select="regex-group(3)"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="regex-group(4)">
                        <xsl:attribute name="subtype">
                            <xsl:value-of select="regex-group(5)"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="textparts2">
                        <xsl:with-param name="textparts2" select="$all"/>
                    </xsl:call-template>
                </div>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:variable name="all" select="."/>
                <xsl:call-template name="ab">
                    <xsl:with-param name="text" select="$all"/>
                </xsl:call-template>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="textparts2">
        <xsl:param name="textparts2"/>
        <xsl:analyze-string regex="(&lt;D=)(\.([\w\d]{{1,3}}))?(\.(\w+))?(.*)(=D&gt;)" select="normalize-space($textparts2)" flags="s">
            <xsl:matching-substring>
                <xsl:variable name="all" select="regex-group(6)"/>
                <div type="textpart">
                    <xsl:if test="regex-group(2)">
                        <xsl:attribute name="n">
                            <xsl:value-of select="regex-group(3)"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="regex-group(4)">
                        <xsl:attribute name="subtype">
                            <xsl:value-of select="regex-group(5)"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="ab">
                        <xsl:with-param name="text" select="$all"/>
                    </xsl:call-template>
                </div>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:variable name="all" select="."/>
                <xsl:call-template name="ab">
                    <xsl:with-param name="text" select="$all"/>
                </xsl:call-template>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    
    <xsl:template name="ab">
        <xsl:param name="text"/>
        <xsl:analyze-string regex="(&lt;=)(.*)(=&gt;)" select="$text">
            <xsl:matching-substring>
                <xsl:variable name="text" select="regex-group(2)"/>
                <ab>
                    <xsl:call-template name="lb">
                        <xsl:with-param name="text" select="$text"/>
                    </xsl:call-template>
                </ab>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="lb">
        <xsl:param name="text"/>
        <xsl:analyze-string regex="(\d\.)(-?)" select="$text">
            <xsl:matching-substring>
                <lb>
                    <xsl:attribute name="n">
                        <xsl:value-of select="substring-before(regex-group(1), '.')"/>
                    </xsl:attribute>
                    <xsl:if test="regex-group(2)">
                        <xsl:attribute name="break">no</xsl:attribute>
                    </xsl:if>
                </lb>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:variable name="text2" select="."/>
                <xsl:call-template name="abbr">
                    <xsl:with-param name="text2" select="$text2"/>
                </xsl:call-template>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="abbr">
        <xsl:param name="text2"/>
        <xsl:analyze-string regex="(\((\w+)(\((\w+)\))\))" select="$text2">
            <xsl:matching-substring>
                <expan>
                    <abbr>
                        <xsl:value-of select="regex-group(2)"/>
                    </abbr>
                    <ex>
                        <xsl:value-of select="regex-group(4)"/>
                    </ex>
                </expan>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:variable name="text3" select="."/>
                <xsl:call-template name="choiceCorrSic">
                    <xsl:with-param name="text3" select="$text3"/>
                </xsl:call-template>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="choiceCorrSic">
        <xsl:param name="text3"/>
        <xsl:analyze-string regex="((&lt;:)(\w+)(\|corr\|)(\w+)(:&gt;))" select="$text3">
            <xsl:matching-substring>
                <choice>
                    <corr>
                        <xsl:value-of select="regex-group(3)"/>
                    </corr>
                    <sic>
                        <xsl:value-of select="regex-group(5)"/>
                    </sic>
                </choice>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:variable select="." name="text4"/>
                <xsl:call-template name="supplied">
                    <xsl:with-param name="text4" select="$text4"/>
                </xsl:call-template>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="supplied">
        <xsl:param name="text4"/>
        <xsl:analyze-string regex="(\[)([a-z\s]+)(\])" select="$text4">
            <xsl:matching-substring>
                <supplied reason="lost">
                   <xsl:value-of select="regex-group(2)"/>
                </supplied>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:variable select="." name="text5"/>
                <xsl:call-template name="omitted">
                    <xsl:with-param name="text5" select="$text5"/>
                </xsl:call-template>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="omitted">
        <xsl:param name="text5"/>
        <xsl:analyze-string regex="(&lt;)([a-z\s]+)(&gt;)" select="$text5">
            <xsl:matching-substring>
                <supplied reason="omitted">
                    <xsl:value-of select="regex-group(2)"/>
                </supplied>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:variable select="." name="text6"/>
                <xsl:call-template name="surplus">
                    <xsl:with-param name="text6" select="$text6"/>
                </xsl:call-template>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="surplus">
        <xsl:param name="text6"/>
        <xsl:analyze-string regex="(\{{)([a-z\s]+)(\}})" select="$text6">
            <xsl:matching-substring>
                <surplus>
                    <xsl:value-of select="regex-group(2)"/>
                </surplus>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:variable select="." name="text6"/>
                <xsl:call-template name="unclear">
                    <xsl:with-param name="text6" select="$text6"/>
                </xsl:call-template>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    
    <xsl:template name="unclear">
        <xsl:param name="text6"/>
        <xsl:analyze-string regex="(\ẉ)" select="$text6">
            <xsl:matching-substring>
                <unclear>
                    <xsl:value-of select="substring-before(., '̣')"/>
                </unclear>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:variable select="." name="text6"/>
                <xsl:call-template name="gap">
                    <xsl:with-param name="text6" select="$text6"/>
                </xsl:call-template>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="gap">
        <xsl:param name="text6"/>
        <xsl:analyze-string regex="\.\?" select="$text6">
            <xsl:matching-substring>
                <gap reason="lost" extent="unknown" unit="character"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
</xsl:stylesheet>