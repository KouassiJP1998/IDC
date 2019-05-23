<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
    <xsl:output method="xml" indent="yes" />
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[name()='text']/*[name()='body']/*[name()='p']">
        <xsl:element name="{local-name()}" xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates select="*[name()='s']"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="*[name()='s']">
        <xsl:element name="{local-name()}" xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates select=".//*[name()='w'] | .//*[name()='pc']"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="w | pc">
        <xsl:element name="{local-name()}" xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="node()|@*"/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
