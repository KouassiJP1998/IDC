<?xml version="1.0" encoding="UTF-8"?>
<!--
XSLT pour transformation des balises  phr en balise NomLieux 
comme indiquer il nous faut des balises Lieu ( qui indique le noeud) et des balises relation qui vont indiquer la direction, il faut egalement récuperer les motions pour indiquer le verbe
GUICHARROUSSE PAUL HENRY
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
        <xsl:output method="xml" indent="yes" />
        
       <xsl:template match="node()|@*">
            <xsl:copy>
                <xsl:apply-templates select="node()|@*"/>
            </xsl:copy>
        </xsl:template>
    
        <!--Creation id unique et nom pour le début-->
        <xsl:template match="*[name()='TEI']">
            <xsl:element name="Parcours">
                <xsl:element name="Lieux">
                    <xsl:attribute name="name">Pralognan</xsl:attribute>
                        <xsl:attribute name="id">
                        <xsl:value-of select="generate-id(.)"/>
                    </xsl:attribute>
                    <xsl:attribute name="relation">fleche</xsl:attribute>
                </xsl:element>
                <xsl:apply-templates select=".//*[name()='phr']"/>
            </xsl:element>
        </xsl:template>
        
        
        <xsl:template match="*[name()='phr']">
            <xsl:apply-templates select=".//*[name()='placeName']"/>
        </xsl:template>
        
        
    <xsl:template match="*[name()='placeName']">
            <xsl:element name="Lieux">
                <xsl:attribute name="Nom">
                    <xsl:for-each select=".//*[name()='w']">
                        <xsl:copy-of select="node()"/>
                    </xsl:for-each>
                </xsl:attribute>
                <!--Genération d'un Id a l'aide la fonction generate.id() -->
                <xsl:attribute name="id">
                    <xsl:value-of select="generate-id(.)"/>
                </xsl:attribute> 
                <!--Attribut direction qui prend en compte le lemma du verbe -->
                <xsl:attribute name="direction">
                    <xsl:value-of select="ancestor::*/*[name()='w'][@type = 'V'][1]/@lemma"/>
                </xsl:attribute>
                <!--Deux possibilites soit fléche ou soit vide-->
                <xsl:choose>
                      <xsl:when test="ancestor::*/@subtype = 'motion'">
                        <xsl:attribute name="relation">fleche</xsl:attribute>
                    </xsl:when>
                               
                    <xsl:otherwise>
                        <xsl:attribute name="relation">vide</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:element>
        </xsl:template>
        
    
    
    
</xsl:stylesheet>