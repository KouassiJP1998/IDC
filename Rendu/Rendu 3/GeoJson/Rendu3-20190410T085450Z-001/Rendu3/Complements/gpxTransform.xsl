<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="1.0">

  <xsl:output method="xml" indent="yes" />
         
     <xsl:template match="node()|@*">
         <xsl:copy>
             <xsl:apply-templates select="node()|@*"/>
         </xsl:copy>
     </xsl:template>
    
    <xsl:template match="*[name()='text']/*[name()='body']/*[name()='p']/*[name()='s']">
            <xsl:apply-templates select="*[name()='phr'] | *[name()='placeName']"/>
    </xsl:template>
    
    <xsl:template match="*[name()='phr']">

        <xsl:if test=".//*[name()='placeName' and @key]">
      
            <xsl:element name="{local-name()}" xmlns="http://www.tei-c.org/ns/1.0">
                <xsl:copy-of select="@*"/>
                
                <xsl:if test="child::node()[2][name()='w']">
                    <xsl:attribute name="phrtest"><xsl:value-of select="child::node()[2]/@lemma"/></xsl:attribute>
                </xsl:if>
                
                <xsl:apply-templates select=" *[name()='placeName'] "/>
            </xsl:element>
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="*[name()='placeName']">
       
        <xsl:choose>
            <xsl:when test="@key">
                <xsl:element name="{local-name()}" xmlns="http://www.tei-c.org/ns/1.0">
                    <xsl:copy-of select="@* "/> 
                    <xsl:apply-templates select=" .//*[name()='placeName'] "/>
                </xsl:element> 
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select=" .//*[name()='placeName'] "/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    
</xsl:stylesheet>