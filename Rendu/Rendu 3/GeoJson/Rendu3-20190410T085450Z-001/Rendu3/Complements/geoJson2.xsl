<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text" indent="yes" />
    
    <xsl:template match="/">
        {
        "type": "FeatureCollection",
        "features": [
            <xsl:apply-templates select="node() | @*"/>
            ]
        }
    </xsl:template>
    
    <xsl:template match="*[name()='placeName']">
        
        <xsl:variable name="key" select="@key"/>
        <xsl:variable name="geonameId">
            <xsl:if test="contains(./@key, 'geonames')">
                <xsl:value-of select="substring-after(@key, ' ')"/>
            </xsl:if>
        </xsl:variable>
        
        <xsl:variable name="latitude">
            <xsl:choose>
                <xsl:when test="document('../listeLieux2.xml')//Lieu[@key = $key]/barycentre">
                        <xsl:value-of
                            select="document('../listeLieux2.xml')//Lieu[@key = $key]/barycentre/point/@latitude"
                        />      
                </xsl:when>
                <xsl:otherwise>
                        <xsl:value-of
                            select="document('../listeLieux2.xml')//Lieu[@key = $key]/point/@latitude"
                        />
                </xsl:otherwise>
            </xsl:choose>    
        </xsl:variable>
        
        <xsl:variable name="longitude">
            <xsl:choose>
                <xsl:when test="document('../listeLieux2.xml')//Lieu[@key = $key]/barycentre">
                    <xsl:value-of
                        select="document('../listeLieux2.xml')//Lieu[@key = $key]/barycentre/point/@longitude"
                    />      
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                        select="document('../listeLieux2.xml')//Lieu[@key = $key]/point/@longitude"
                    />
                </xsl:otherwise>
            </xsl:choose>    
        </xsl:variable>

        <xsl:variable name="name">
            <xsl:choose>
                <xsl:when test="document('../listeLieux2.xml')//Lieu[@key = $key]/barycentre">
                    <xsl:value-of
                        select="document('../listeLieux2.xml')//Lieu[@key = $key]/barycentre/point/@name"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                        select="document('../listeLieux2.xml')//Lieu[@key = $key]/point/@name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="listeLieux" select="document('../listeLieux2.xml')//Lieu[@key = $key]/child::node()[name() = 'point']"/>
        
        <xsl:variable name="typePoints">
            <xsl:choose>
                <xsl:when test="$listeLieux[1]/@longitude = $listeLieux[last()]/@longitude and $listeLieux[1]/@latitude = $listeLieux[last()]/@latitude and  document('../listeLieux2.xml')//Lieu[@key = $key]/barycentre"><xsl:text>boucle</xsl:text></xsl:when>
                <xsl:when test="$listeLieux[1]/@longitude != $listeLieux[last()]/@longitude or $listeLieux[1]/@latitude != $listeLieux[last()]/@latitude and  document('../listeLieux2.xml')//Lieu[@key = $key]/barycentre"><xsl:text>route</xsl:text></xsl:when>
                <xsl:otherwise><xsl:text>point</xsl:text></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        {
            "type": "Feature",
            "properties": {
                "geonameId": "<xsl:value-of select="$geonameId"/>",
                "countryCode": "FR",
                "name": "<xsl:value-of select="$name"/>",
                "id": "<xsl:value-of select="@xml:id"/>",
                "lat": "<xsl:value-of select="$latitude"/>",
                "lng": "<xsl:value-of select="$longitude"/>",
                "fcl": "<xsl:value-of select="child::node()[name()='geogName']/@type"/>",
                "fcode": "<xsl:value-of select="child::node()[name()='geogName']/@subtype"/>"
            },
            "geometry": {
                
                
                <xsl:choose>
                    <!-- Si c'est une boucle -->
                    <xsl:when test="$typePoints = 'boucle'">
                        "type": "Polygon",
                        "coordinates": [
                        [<xsl:for-each select="$listeLieux">[<xsl:value-of select="@longitude"/>, <xsl:value-of select="@latitude"/>]<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>]
                        ]
                        }
                    </xsl:when>
                    <!-- Si c'est une route -->
                    <xsl:when test="$typePoints = 'route'">
                        "type": "LineString",
                        "coordinates": [
                        <xsl:for-each select="$listeLieux">[<xsl:value-of select="@longitude"/>, <xsl:value-of select="@latitude"/>]<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>
                        ]
                        }
                    </xsl:when>
                    <!-- Si c'est un point -->
                    <xsl:otherwise>
                        "type": "Point",
                        "coordinates": 
                        [<xsl:value-of select="$longitude"/>, <xsl:value-of select="$latitude"/>]
                        
                        }  
                    </xsl:otherwise>
                </xsl:choose>
        
        }<xsl:if test="following::*//@xml:id">,</xsl:if>
        
        <xsl:apply-templates select=" .//*[name()='placeName'] "/>
    </xsl:template>
    
</xsl:stylesheet>