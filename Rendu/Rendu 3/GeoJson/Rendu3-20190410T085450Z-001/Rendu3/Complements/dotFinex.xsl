<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="node()|@*">
digraph {
        <xsl:apply-templates select="node()|@*" mode="etape1"/>
        <xsl:apply-templates select="node()|@*" mode="etape2"/>
}
    </xsl:template>
    
    <xsl:template match="*[name() = 'liste']/*[name()='lieu']" mode="etape1">
        <xsl:value-of select="@id"/> [label="<xsl:value-of select="@name"/>"]
        <xsl:choose>
            <xsl:when test="not(direct-edge/@id)">
                [shape=box];
            </xsl:when>
            <xsl:otherwise>
                ;
            </xsl:otherwise>
        </xsl:choose>
    
    </xsl:template>
     
    <xsl:template match="*[name() = 'liste']/*[name()='lieu']" mode="etape2"> 
        
        <xsl:if test="direct-edge/@id !=''">
            <xsl:value-of select="@id"/> -> <xsl:value-of select="direct-edge/@id"/><xsl:if test="direct-edge/@info">[label= <xsl:value-of select="direct-edge/@info"/> fontcolor=cadetblue]</xsl:if>;   
        </xsl:if>
        
        <xsl:apply-templates select="*[name() = 'infoPlace']"/>
    </xsl:template>
    
  
    <xsl:template match="*[name() = 'infoPlace']">       
        <xsl:if test="@id !=''">
            <xsl:value-of select="parent::node()/@id"/> -> <xsl:value-of select="@id"/> [style=dotted dir=none]<xsl:if test="@info">[label= <xsl:value-of select="@info"/> fontcolor=cadetblue]</xsl:if>;  
        </xsl:if>    
    </xsl:template>
    
</xsl:stylesheet>