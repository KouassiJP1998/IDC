<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!--****************************************-->
    <!--      COMBINAISON DES TRAITEMENTS       -->
    <!--****************************************-->
    
    <xsl:template match="/">
        
        <!-- On créer une variable qui applique un premier traitement sur un fichier xml afin de récupérer les balises placename et geogname-->
        
        <xsl:variable name="resultPart1">
            <resultPart1>
                <xsl:copy>
                    <xsl:apply-templates select="node() | @*" mode="phase1"/>
                </xsl:copy>
            </resultPart1>
        </xsl:variable>
        
        <xsl:apply-templates mode="phase2" select="$resultPart1"/>

    </xsl:template>
    
    
    <!--****************************************-->
    <!-- ACTIONS RELATIVES AU PREMIER TRAITEMENT-->
    <!--****************************************-->
    
    
    <xsl:template match="node()|@*" mode="phase1">
        <xsl:apply-templates select="node()|@*" mode="phase1"/>
    </xsl:template>
    
    <!-- On match sur les balises placename et geogName pour les récupérer-->
    <!-- La balise geogname est importante pour récupérer le fcl et le fcode -->
    
    <xsl:template match="*[name()='placeName']" mode="phase1">
        <xsl:choose>
            <xsl:when test="@key">
                <xsl:element name="{local-name()}">
                    <xsl:copy-of select="@* "/>
                    <xsl:apply-templates select=" *[name()='geogName'] " mode="phase1"/>
                    <xsl:apply-templates select=" .//*[name()='placeName'] " mode="phase1"/>
                </xsl:element> 
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select=" .//*[name()='placeName'] " mode="phase1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*[name()='geogName']" mode="phase1">
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@* "/> 
        </xsl:element> 
    </xsl:template>
    
    <!--****************************************-->
    <!-- ACTIONS RELATIVES AU SECOND TRAITEMENT -->
    <!--****************************************-->
    
    
    <!-- On match sur les resultats du phases1 pour récupérer les informations du FeatureCollection-->
    <xsl:template match="resultPart1" mode="phase2">
        {
        "type": "FeatureCollection",
        "features": [
        <xsl:apply-templates select="node() | @*" mode="phase2"/>
        ]
        }
    </xsl:template>
    
    <xsl:template match="*[name()='placeName']" mode="phase2">
        
        <!-- On match sur la balise placeName pour récupérer l'attribut key-->
        <xsl:variable name="key" select="@key"/>
        
        <!-- On fait un traitement sue les keys qui contienent l'intitulé geonames pour avoir juste les id du geoname -->
        <xsl:variable name="geonameId">
            <xsl:if test="contains(./@key, 'geonames')">
                <xsl:value-of select="substring-after(@key, ' ')"/>
            </xsl:if>
        </xsl:variable>
        
        <!-- On fait le test pour récupérer latitude, longitude et le name  sur les lieu qui contients des barycentres et des point, 
            on fait en sorte que notre test traite tout les cas d'apparition de latitude, longitude et le name -->
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
        
        <!-- On récupére la liste des points relatifs au lieux-->
        <xsl:variable name="typePoints">
            <xsl:choose>
                <xsl:when test="$listeLieux[1]/@longitude = $listeLieux[last()]/@longitude and $listeLieux[1]/@latitude = $listeLieux[last()]/@latitude and  document('../listeLieux2.xml')//Lieu[@key = $key]/barycentre"><xsl:text>boucle</xsl:text></xsl:when>
                <xsl:when test="$listeLieux[1]/@longitude != $listeLieux[last()]/@longitude or $listeLieux[1]/@latitude != $listeLieux[last()]/@latitude and  document('../listeLieux2.xml')//Lieu[@key = $key]/barycentre"><xsl:text>route</xsl:text></xsl:when>
                <xsl:otherwise><xsl:text>point</xsl:text></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <!-- On compléte notre fichier json avec les variables précédentes-->
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
        
        <!-- On compléte la liste des points -->
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
        <!-- On regarde si c'est le dernier placename -->
        }<xsl:if test="following::*//@xml:id">,</xsl:if>
        
        <xsl:apply-templates select=" .//*[name()='placeName'] " mode="phase2"/>
    </xsl:template>
    
</xsl:stylesheet>