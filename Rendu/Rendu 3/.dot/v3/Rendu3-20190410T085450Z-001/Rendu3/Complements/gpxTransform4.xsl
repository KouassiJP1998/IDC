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
        
        <xsl:variable name="id" select="substring-after(@xml:id,'.')"/>
        <xsl:variable name="key" select="@key"/>
        <xsl:variable name="contextInfo" select="following::node()"/>
        <xsl:variable name="nextPlaceName" select="following::*//@xml:id"/>
        
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

                <xsl:choose>
                    <xsl:when test="($contextInfo[1]/name() = 'phr' and $contextInfo[1]/@subtype = 'motion') or $contextInfo[1]/name() = 'placeName'">
                        <xsl:attribute name="id"><xsl:value-of select="substring-after($nextPlaceName[1],'.')"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="id"><xsl:value-of select="substring-after($nextPlaceName[2],'.')"/></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                
            </direct-edge>
            
            <!-- Si un placeName a des enfants placeName, ceux-ci sont la a titre informatif -->

            <xsl:for-each select="child::node()">
                <xsl:if test="@xml:id">
                    <infoPlace><xsl:attribute name="id"><xsl:value-of select="substring-after(@xml:id,'.')"/></xsl:attribute></infoPlace>
                </xsl:if>
            </xsl:for-each>
            
            
            <!-- Si un phr de type perception existe juste apres-->
            
            <xsl:if test="$contextInfo[1]/name() = 'phr'">
                <xsl:if test="$contextInfo[1]/@subtype = 'perception'">
                    <infoPlace><xsl:attribute name="id"><xsl:value-of select="$contextInfo[2]/substring-after(@xml:id,'.')"/></xsl:attribute></infoPlace>
                </xsl:if>
                
            </xsl:if>
            
        </lieu>
        
        <!-- on crée les lieux qui sont présent qu'a titre informatif -->
        
        <xsl:for-each select="child::node()">
            
            <xsl:variable name="id" select="substring-after(@xml:id,'.')"/>
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
        <xsl:variable name="id" select="substring-after(@xml:id,'.')"/>
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
    </xsl:template>
    
</xsl:stylesheet>