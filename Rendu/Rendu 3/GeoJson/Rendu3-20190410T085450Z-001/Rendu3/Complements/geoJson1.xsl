<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" indent="yes" />
    
    <xsl:template match="/">
        <liste>
            <xsl:apply-templates select="node() | @*"/>
        </liste>
    </xsl:template>
    
    <xsl:template match="node()|@*">
            <xsl:apply-templates select="node()|@*"/>
    </xsl:template>
    
    <xsl:template match="*[name()='placeName']">
        <xsl:choose>
            <xsl:when test="@key">
                <xsl:element name="{local-name()}">
                    <xsl:copy-of select="@* "/>
                    <xsl:apply-templates select=" *[name()='geogName'] "/>
                    <xsl:apply-templates select=" .//*[name()='placeName'] "/>
                </xsl:element> 
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select=" .//*[name()='placeName'] "/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*[name()='geogName']">
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@* "/> 
        </xsl:element> 
    </xsl:template>
    
</xsl:stylesheet>