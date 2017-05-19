<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: txt-teisupplied.xsl 2354 2015-05-08 16:28:41Z paregorios $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:t="http://www.tei-c.org/ns/1.0" version="2.0">
  <!-- Called from teisupplied.xsl -->
  
  <xsl:template name="supplied-parallel">
    <xsl:call-template name="unicode-underline"/>
  </xsl:template>
  
  <xsl:template name="supplied-previouseditor">
    <xsl:call-template name="unicode-underline"/>
  </xsl:template>
  
  <xsl:template name="unicode-underline">
    <xsl:analyze-string select="." regex="([A-Za-z])">
      <xsl:matching-substring>
        <xsl:for-each select="regex-group(1)">
          <xsl:value-of select="concat(.,'̲')"/>
        </xsl:for-each>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:template>

</xsl:stylesheet>