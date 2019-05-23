<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>   
        </xsl:copy>
        
    </xsl:template>
    
    <xsl:template match="*[name() = 'text']/*[name() = 'body']/*[name() = 'p']">
        <xsl:apply-templates select="*[name() = 'phr'] | *[name() = 'placeName']"/>
    </xsl:template>
    
    <xsl:template match="*[name() = 'phr']">
        <xsl:if test="@subtype = 'motion'">
            <xsl:apply-templates select="*[name() = 'placeName']"/>
        </xsl:if>
        <xsl:if test="@subtype = 'perception'">
            <xsl:apply-templates select="*[name() = 'placeName']"  mode="viewInPhr"/>
        </xsl:if>
    </xsl:template>
    
    <!-- PlaceName seul et dans phr-->
    
    <xsl:template match="*[name() = 'placeName']">
        <xsl:variable name="id" select="@xml:id"/>
        <xsl:variable name="key" select="@key"/>
        
        <lieu>
            <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
            <xsl:attribute name="name">
                <xsl:choose>
                    <xsl:when test="document('/home/25/spedebearn/Bureau/rendu3Esquisse/GPX/listeLieux2.xml')//Lieu[@key = $key]/barycentre">
                        <xsl:value-of
                            select="document('/home/25/spedebearn/Bureau/rendu3Esquisse/GPX/listeLieux2.xml')//Lieu[@key = $key]/barycentre/point/@name"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="document('/home/25/spedebearn/Bureau/rendu3Esquisse/GPX/listeLieux2.xml')//Lieu[@key = $key]/point/@name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <direct-edge>   
                <!-- Récupération du placeName premier placeName suivant en regardant si il est dans un phr de type view ou non-->
                <xsl:variable name="nextPlaceName" select="following::*[1]//@xml:id"/>
                <xsl:value-of select="$nextPlaceName[1]"/>
            </direct-edge>
            
            <!-- Si un placeName a des enfants placeName, ceux-ci sont la a titre informatif -->
            <xsl:if test="$phrInfo[1]/name() = 'phr'">
                <xsl:for-each select="child::node()">
                    <xsl:if test="@xml:id">
                        <infoPlace><xsl:value-of select="@xml:id"/></infoPlace>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
            
            <!-- Si un phr de type perception existe juste apres-->
            
            <xsl:variable name="phrInfo" select="following::node()"/>
            
            <xsl:if test="$phrInfo[1]/name() = 'phr'">
                <xsl:if test="$phrInfo[1]/@subtype = 'perception'">
                    <infoPlace><xsl:value-of select="$phrInfo[2]/@xml:id"/></infoPlace>
                </xsl:if>
                
            </xsl:if>
            
        </lieu>
        
        <!-- on crée les lieux qui sont présent qu'a titre informatif -->
        
        <xsl:for-each select="child::node()">
            
            <xsl:variable name="id" select="@xml:id"/>
            <xsl:variable name="key" select="@key"/>
            
            <lieu>
                <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
                <xsl:attribute name="name">
                    <xsl:choose>
                        <xsl:when test="document('/home/25/spedebearn/Bureau/rendu3Esquisse/GPX/listeLieux2.xml')//Lieu[@key = $key]/barycentre">
                            <xsl:value-of
                                select="document('/home/25/spedebearn/Bureau/rendu3Esquisse/GPX/listeLieux2.xml')//Lieu[@key = $key]/barycentre/point/@name"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="document('/home/25/spedebearn/Bureau/rendu3Esquisse/GPX/listeLieux2.xml')//Lieu[@key = $key]/point/@name"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </lieu>
        
        </xsl:for-each>
          
    </xsl:template>
    
    <!-- PlaceName dans phr -->
    
    <xsl:template match="*[name() = 'placeName']" mode="viewInPhr">
        view   
    </xsl:template>
    
    
    
    <xsl:template match="*[name() = 'placeName']" mode="inside">
    
    </xsl:template>
    
    <xsl:template match="*[name() = 'placeName']" mode="phr">
    
    </xsl:template>
    
</xsl:stylesheet>