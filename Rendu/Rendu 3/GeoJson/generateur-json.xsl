<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes" indent="no" media-type="application/json" />
    <xsl:strip-space elements="*" />
    
    <xsl:param name="coordonnes" select="document('./coordonnee.xml')"/>
    <xsl:param name="pralognan" select="document('./fr_pralognan.xml')" />
    
    <xsl:template match="/">
        <xsl:text></xsl:text>
        
        
        <xsl:for-each select="*">
            <xsl:text>
        {"type": "FeatureCollection",
        "features": [</xsl:text>
            <xsl:call-template name="processNode" />
        </xsl:for-each>
        
        
        <xsl:text>]}</xsl:text>
    </xsl:template>
    
    <xsl:template name="processNode">
        <xsl:variable name="id" select="./@key"/>
        <xsl:variable name="corpus" select="./@corpus"/>
        
        
        <!-- Output the node name + open array (only if we aren't already in an array) -->
        <!-- Output the node name + open array (only if we aren't already in an array) -->
        <xsl:if test="count(preceding-sibling::*[name() = name(current())]) = 0">
            
            <xsl:choose>
                <xsl:when test="contains(./@key, 'osm')">
                    <xsl:text>"</xsl:text>osm<xsl:text>":</xsl:text>
                </xsl:when>
                <xsl:when test="contains(./@key, 'geonames')">
                    <xsl:text>"</xsl:text>geonames<xsl:text>":</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>
                    </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>
            </xsl:text>
            <xsl:if test="count(following-sibling::*[name() = name(current())]) &gt; 0">
                <xsl:text>[</xsl:text>
            <xsl:text>
            </xsl:text>
            </xsl:if>
        </xsl:if>
        
        <xsl:text>{</xsl:text>
        <xsl:text>
        </xsl:text>

        
        <xsl:text>"type": "Feature"</xsl:text>
        <xsl:text>,"properties": {</xsl:text>
        <xsl:text>"lng":"</xsl:text><xsl:value-of select="current()/@lng"/><xsl:text>"</xsl:text>
        <xsl:text>
       </xsl:text>
        
        <xsl:text>,"geonameId":"</xsl:text><xsl:call-template name="tokenize">
            <xsl:with-param name="str" select="normalize-space(@key)"/>
        </xsl:call-template><xsl:text>"</xsl:text>
        <xsl:text>
       </xsl:text>
        <xsl:text>,"countryCode": "FR"</xsl:text>
        
        <xsl:choose>
            <xsl:when test="string(.)">
                <xsl:text>,"name":"</xsl:text><xsl:call-template name="escape"><xsl:with-param name="text" select="text()" /></xsl:call-template><xsl:text>"</xsl:text>
                <xsl:text>,"toponymName":"</xsl:text><xsl:call-template name="escape"><xsl:with-param name="text" select="text()" /></xsl:call-template><xsl:text>"</xsl:text>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
        
        <xsl:text>
       </xsl:text>
        
        <xsl:text>,"id":"</xsl:text><xsl:value-of select="current()/@id"/><xsl:text>"</xsl:text>
        <xsl:text>
       </xsl:text>
        
        <xsl:text>,"lat":"</xsl:text><xsl:value-of select="current()/@lat"/><xsl:text>"</xsl:text>
        <xsl:text>
       </xsl:text>
       <!-- <xsl:if test="$pralognan//tei:placeName[@key=$id]//tei:geogName/@type">-->
            <xsl:text>,"fcl":"</xsl:text><xsl:value-of select="$pralognan//tei:placeName[@key=$id]//tei:geogName/@type"/><xsl:text>"</xsl:text>
            <xsl:text>
       </xsl:text>
       <xsl:text>,"fcode":"</xsl:text><xsl:value-of select="$pralognan//tei:placeName[@key=$id]//tei:geogName/@subtype"/><xsl:text>"</xsl:text>
        
        <xsl:text>},"geometry": {</xsl:text>
        <xsl:text>"type":</xsl:text>
        <xsl:choose>
            <xsl:when test="not(./@lng)">
                <xsl:text>"LineString","coordinates": [</xsl:text>
                <xsl:for-each select="./entite_spatiale | ./entite_spatiale/entite_spatiale">
                    <xsl:if test="./@lng">
                        [<xsl:value-of select="./@lng"/>,<xsl:value-of select="./@lat"/>]
                        <xsl:if test="position() != last()">,</xsl:if></xsl:if>
                </xsl:for-each>]
            </xsl:when>
            <xsl:otherwise>
                "Point","coordinates": [
                <xsl:value-of select="./@lng"/>,
                <xsl:value-of select="./@lat"/>
                ]  
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>}</xsl:text>
        <!--</xsl:if>-->
        <!--</xsl:if>-->
       
        
        <!-- Process sub nodes -->
        <xsl:for-each select="*">
            <xsl:if test="count(preceding-sibling::*[name() = name(current())]) = 0">
                <xsl:text>,</xsl:text>
                <xsl:text>
                </xsl:text>
                <xsl:call-template name="processNode" />
            </xsl:if>
        </xsl:for-each>
        
        <xsl:text>}</xsl:text>
        
        
        
        
        
        <!-- Process following sub nodes with the same node name as array -->
        <xsl:if test="count(preceding-sibling::*[name() = name(current())]) = 0">
            <xsl:for-each select="following-sibling::*[name() = name(current())]">
                <xsl:text>,</xsl:text>
                <xsl:text>
                </xsl:text>
                <xsl:call-template name="processNode" />
            </xsl:for-each>
        </xsl:if>
        
        
        
        
        <!-- Close array -->
        <xsl:if test="count(preceding-sibling::*[name() = name(current())]) &gt; 0">
            <xsl:if test="count(following-sibling::*[name() = name(current())]) = 0">
                <xsl:text>]</xsl:text>
                <xsl:if test="position() != last()">
                <xsl:text>,
                </xsl:text>
                </xsl:if>
                
            </xsl:if>
        </xsl:if>
            
        
    </xsl:template>
    
    <!-- Replace characters which could cause an invalid JS object, by their escape-codes. -->
    <xsl:template name="escape">
        <xsl:param name="text" />
        <xsl:param name="char" select="'\'" />
        <xsl:param name="nextChar" select="substring(substring-after('\/&quot;&#xD;&#xA;&#x9;',$char),1,1)" />
        
        <xsl:choose>
            <xsl:when test="$char = ''">
                <xsl:value-of select="$text" />
            </xsl:when>
            
            <xsl:when test="contains($text,$char)">
                <xsl:call-template name="escape">
                    <xsl:with-param name="text" select="substring-before($text,$char)" />
                    <xsl:with-param name="char" select="$nextChar" />
                </xsl:call-template>
                <xsl:value-of select="concat('\',translate($char,'&#xD;&#xA;&#x9;','nrt'))" />
                <xsl:call-template name="escape">
                    <xsl:with-param name="text" select="substring-after($text,$char)" />
                    <xsl:with-param name="char" select="$char" />
                </xsl:call-template>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:call-template name="escape">
                    <xsl:with-param name="text" select="$text" />
                    <xsl:with-param name="char" select="$nextChar" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="tokenize">
        <xsl:param name="str"/>
        <xsl:value-of select="substring-after($str, ' ')"/>
    </xsl:template>
</xsl:stylesheet>