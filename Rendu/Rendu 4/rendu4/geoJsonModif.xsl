<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="adresseDocumentLieux" select="document('./listeLieux.xml')"/>  
    
    <xsl:template match="/">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="phase2"/>
        </xsl:copy>
    </xsl:template>
    
 
    <!-- On match sur les resultats du phases1 pour récupérer les informations du FeatureCollection-->
    <xsl:template match="liste" mode="phase2">
        {
        "type": "FeatureCollection",
        "features": [
        <xsl:apply-templates select="node() | @*" mode="phase2"/>
        ]
        }
    </xsl:template>
    
    <xsl:template match="*[name()='Lieu']" mode="phase2">
        
        <!-- On match sur la balise placeName pour récupérer l'attribut key-->
        <xsl:variable name="key" select="@key"/>
        
        <!-- On fait un traitement sue les keys qui contienent l'intitulé geonames pour avoir juste les id du geoname -->
        <xsl:variable name="geonameId">
            <xsl:if test="contains(./@key, 'geonames')">
                <xsl:value-of select="substring-after(@key, ' ')"/>
            </xsl:if>
        </xsl:variable>
        
        <xsl:variable name="nomFichier">
            <xsl:choose>
                <xsl:when test="$adresseDocumentLieux//Lieu[@key = $key]">
                    <xsl:value-of
                        select="$adresseDocumentLieux//Lieu[@key = $key]/document/@docOrigine"
                    />      
                </xsl:when>
            </xsl:choose>    
        </xsl:variable>
        
        <xsl:variable name="couleur">
            <xsl:choose>
                <xsl:when test="$nomFichier = './XMLFiles/1e_jour_de_pralognan_au_refuge_de_la_lei.xml'">#00FECB</xsl:when>
                <xsl:when test="$nomFichier = './XMLFiles/1ere_etape_du_chemin_vers_saint_jacques_.xml'">#82EB00</xsl:when>
                <xsl:when test="$nomFichier = './XMLFiles/2e_jour_du_refuge_de_la_leisse_au_refuge.xml'">#FFD901</xsl:when>
                <xsl:when test="$nomFichier = './XMLFiles/4eme_etape_du_tmb.xml'">#EB8A01</xsl:when>
                <xsl:when test="$nomFichier = './XMLFiles/7eme_etape_du_tmb.xml'">#FF1F0A</xsl:when>
                <xsl:when test="$nomFichier = './XMLFiles/alentours_d_hennebont_et_le_chemin_de_ha.xml'">#FFE98C</xsl:when>
                <xsl:when test="$nomFichier = './XMLFiles/au_depart_de_la_pointe_du_millier.xml'">#E901EA</xsl:when>
                <xsl:when test="$nomFichier = './XMLFiles/1ere_etape_du_tmb.xml'">#EB8DD2</xsl:when>
                <xsl:when test="$nomFichier = './XMLFiles/au_depart_de_merrien.xml'">#FAF8FF</xsl:when>
                <xsl:otherwise>#000000</xsl:otherwise>
            </xsl:choose>
            
        </xsl:variable>        
        <!-- On fait le test pour récupérer latitude, longitude et le name  sur les lieu qui contients des barycentres et des point, 
            on fait en sorte que notre test traite tout les cas d'apparition de latitude, longitude et le name -->
        <xsl:variable name="latitude">
            <xsl:choose>
                <xsl:when test="$adresseDocumentLieux//Lieu[@key = $key]/barycentre">
                    <xsl:value-of
                        select="$adresseDocumentLieux//Lieu[@key = $key]/barycentre/point/@latitude"
                    />      
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                        select="$adresseDocumentLieux//Lieu[@key = $key]/point/@latitude"
                    />
                </xsl:otherwise>
            </xsl:choose>    
        </xsl:variable>
        
        <xsl:variable name="longitude">
            <xsl:choose>
                <xsl:when test="$adresseDocumentLieux//Lieu[@key = $key]/barycentre">
                    <xsl:value-of
                        select="$adresseDocumentLieux//Lieu[@key = $key]/barycentre/point/@longitude"
                    />      
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                        select="$adresseDocumentLieux//Lieu[@key = $key]/point/@longitude"
                    />
                </xsl:otherwise>
            </xsl:choose>    
        </xsl:variable>
        
        <xsl:variable name="name">
            <xsl:choose>
                <xsl:when test="$adresseDocumentLieux//Lieu[@key = $key]/barycentre">
                    <xsl:value-of
                        select="$adresseDocumentLieux//Lieu[@key = $key]/barycentre/point/@name"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                        select="$adresseDocumentLieux//Lieu[@key = $key]/point/@name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="listeLieux" select="$adresseDocumentLieux//Lieu[@key = $key]/child::node()[name() = 'point']"/>
        
        <!-- On récupére la liste des points relatifs au lieux-->
        <xsl:variable name="typePoints">
            <xsl:choose>
                <xsl:when test="$listeLieux[1]/@longitude = $listeLieux[last()]/@longitude and $listeLieux[1]/@latitude = $listeLieux[last()]/@latitude and  $adresseDocumentLieux//Lieu[@key = $key]/barycentre"><xsl:text>boucle</xsl:text></xsl:when>
                <xsl:when test="$listeLieux[1]/@longitude != $listeLieux[last()]/@longitude or $listeLieux[1]/@latitude != $listeLieux[last()]/@latitude and  $adresseDocumentLieux//Lieu[@key = $key]/barycentre"><xsl:text>route</xsl:text></xsl:when>
                <xsl:otherwise><xsl:text>point</xsl:text></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <!-- On compléte notre fichier json avec les variables précédentes-->
        {
        "type": "Feature",
        "properties": {
        "marker-color":"<xsl:value-of select="$couleur"/>",
        "fichierSource" : "<xsl:value-of select="$nomFichier"/>",
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
        }<xsl:if test="following::*//@id">,</xsl:if>
        
        <xsl:apply-templates select=" .//*[name()='placeName'] " mode="phase2"/>
    </xsl:template>
    
</xsl:stylesheet>