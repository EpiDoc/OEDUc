<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:template match="/">
        <xsl:variable name="transformed">
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:value-of select="normalize-space($transformed)"/>
    </xsl:template>
    
    <xsl:template match="t:div[@type='textpart']">
        <xsl:text>&lt;D=.</xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:if test="@subtype">
            <xsl:text>.</xsl:text>
        <xsl:value-of select="@subtype"/>
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:text>=D&gt;</xsl:text>
    </xsl:template>
   
    <xsl:template match="t:ab">
        <xsl:text>&lt;=</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>=&gt;</xsl:text>
    </xsl:template>
    
    <xsl:template match="t:lb">
        
        <xsl:text> </xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>.</xsl:text>
        <xsl:if test="@break='no'">-</xsl:if>
        
    </xsl:template>
    
    <xsl:template match="t:choice[t:corr][t:sic]">
        <xsl:text>&lt;:</xsl:text>
        <xsl:value-of select="t:sic"/>
        <xsl:text>|corr|</xsl:text>
        <xsl:value-of select="t:corr"/>
        <xsl:text>:&gt;</xsl:text>
    </xsl:template>
    
<!--    stupid, needs templating-->
    <xsl:template match="t:expan[t:abbr][t:ex]">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="t:abbr"/>
        <xsl:text>(</xsl:text>
        <xsl:value-of select="t:ex"/>
        <xsl:text>))</xsl:text>
    </xsl:template>
    
    <xsl:template match="t:expan[t:abbr[t:am]][t:ex]">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="t:abbr"/>
        <xsl:text>(</xsl:text>
        <xsl:value-of select="t:ex"/>
        <xsl:text>))</xsl:text>
    </xsl:template>
    
    
    <xsl:template match="t:unclear">
        <xsl:value-of select="."/>̣
    </xsl:template>
    
    <xsl:template match="t:surplus">
        <xsl:text>{</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="t:supplied[@reason='lost']">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <xsl:template match="t:del">
        <xsl:text>〚</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>〛</xsl:text>
    </xsl:template>
    

    
    <xsl:template match="t:supplied[@reason='omitted']">
        <xsl:text>&lt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
    </xsl:template>
    
    
    
    <xsl:template match="t:gap[@reason='lost']">
        <xsl:text>.?</xsl:text>
    </xsl:template>
</xsl:stylesheet>