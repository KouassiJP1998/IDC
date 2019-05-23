<?xml version="1.0" encoding="UTF-8"?>

<!--
XSL pour transformer les phr en dag
on creer des balises de type vertex
Bastien DELBOUYS
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
    <xsl:output method="xml" indent="yes" />
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[name()='TEI']">
        <xsl:element name="dag">
            <xsl:apply-templates select=".//*[name()='phr']"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="*[name()='phr']">
            <xsl:apply-templates select=".//*[name()='placeName']"/>
    </xsl:template>
    
    <xsl:template match="*[name()='placeName']">
        <xsl:element name="vertex">
            <xsl:attribute name="name">
                <xsl:for-each select=".//*[name()='w']">
                    <xsl:copy-of select="node()"/>
                    <xsl:if test="position() != last()">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:attribute>
            <xsl:attribute name="id">
                <xsl:value-of select="generate-id(.)"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="ancestor::*/@subtype = 'motion'">
                    <xsl:attribute name="link">arrow</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="link">none</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
