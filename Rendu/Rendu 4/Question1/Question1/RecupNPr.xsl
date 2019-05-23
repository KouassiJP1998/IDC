<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml"></xsl:output>
    <xsl:template match="/">
        <xsl:text>&#xa;</xsl:text>
        <ListNomPropre>
            <xsl:call-template name="getNPr"></xsl:call-template>
            <xsl:text>&#xa;</xsl:text>
        </ListNomPropre>
    </xsl:template>
    <xsl:template name="getNPr">
        <xsl:variable name="text" select="unparsed-text('au_depart_de_merrien.txt', 'utf-8')"></xsl:variable>
        <xsl:analyze-string select="$text" regex="([A-Z][a-z]*[\s|-])*[A-Z][a-z]*">
            <xsl:matching-substring>
                <xsl:text>&#xa;</xsl:text>
                <xsl:element name="NPr">
                    <xsl:value-of select="."></xsl:value-of>
                </xsl:element>
            </xsl:matching-substring>
        </xsl:analyze-string>   
    </xsl:template>
</xsl:stylesheet>