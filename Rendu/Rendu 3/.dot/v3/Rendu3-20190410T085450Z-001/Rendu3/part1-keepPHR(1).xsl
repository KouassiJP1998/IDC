<?xml version="1.0" encoding="UTF-8"?>

<!--
XSL gardant uniquement les phr et leur contenu
Bastien DELBOUYS
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
    <xsl:output method="xml" indent="no" />
    
    
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
        <xsl:apply-templates select=" *[name()='phr']"/>
    </xsl:template>
    
    <xsl:template match="*[name()='phr']">
        <xsl:element name="{local-name()}" xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select=" *[name()='term'] | *[name()='measure']  | *[name()='name'] | *[name()='placeName'] | *[name()='offset'] | *[name()='geogName'] | *[name()='w']"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="*[name()='placeName']">
        <xsl:element name="{local-name()}" xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="*[name()='name'] | *[name()='geogFeat'] | *[name()='geogName'] | *[name()='w']  | *[name()='placeName']"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="*[name()='geogName']">
        <xsl:element name="{local-name()}" xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="*[name()='geogFeat'] | *[name()='w'] | *[name()='placeName'] | *[name()='name']"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="term | name | offset | measure | geogFeat">
        <xsl:element name="{local-name()}" xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="*[name()='w']"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="w">
        <xsl:element name="{local-name()}" xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="node()|@*"/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
