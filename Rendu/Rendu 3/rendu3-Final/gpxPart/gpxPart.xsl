<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <!-- GPX Transformation, Stanislas PEDEBEARN -->
    <!-- Parse un fichier xml comme "fr_pralognan.xml" en fichier GPX. Le résultat est lisible avec tout lecteur de gpx -->

    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="adresseDocumentLieux" select="document('./../usefull/listeLieux.xml')"/>
    
    <!--****************************************-->
    <!--      COMBINAISON DES TRAITEMENTS       -->
    <!--****************************************-->
    
    <xsl:template match="/">

        <!-- On créer une variable qui applique un premier traitement sur un fichier xml afin de récupérer les lieux "correctes" de la trace -->
        
        <xsl:variable name="resultPart1">
            <resultPart1>
                <xsl:copy>
                    <xsl:apply-templates select="node() | @*" mode="phase1"/>
                </xsl:copy>
            </resultPart1>
        </xsl:variable>
        
        <!-- La variable est un arbre balisé auquel on applique un second traitement pour transfomer le tout en fichier GPX -->
        
        <gpx xmlns="http://www.topografix.com/GPX/1/1" creator="byHand" version="1.1"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">
            
            <xsl:apply-templates mode="phase2" select="$resultPart1"/>
        </gpx>
    </xsl:template>

    
    <!--****************************************-->
    <!-- ACTIONS RELATIVES AU PREMIER TRAITEMENT-->
    <!--****************************************-->

    <!-- Dans cette partie, on ne garde que les phr et les placeName qui peuvent fournir des infos de géolocalisation -->
    
    <xsl:template match="*[name() = 'text']/*[name() = 'body']/*[name() = 'p']/*[name() = 's']"
        mode="phase1">
        <xsl:apply-templates select="*[name() = 'phr'] | *[name() = 'placeName']" mode="phase1"/>
    </xsl:template>
    
    <xsl:template match="*[name() = 'phr']" mode="phase1">
        <xsl:if test=".//*[name() = 'placeName' and @key]">
            <xsl:element name="{local-name()}" xmlns="http://www.tei-c.org/ns/1.0">
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates select="*[name() = 'placeName']" mode="phase1"/>
            </xsl:element>
        </xsl:if>

    </xsl:template>

    <xsl:template match="*[name() = 'placeName']" mode="phase1">

        <xsl:choose>
            <xsl:when test="@key">
                <xsl:element name="{local-name()}" xmlns="http://www.tei-c.org/ns/1.0">
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates select=".//*[name() = 'placeName']" mode="phase1"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select=".//*[name() = 'placeName']" mode="phase1"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!--****************************************-->
    <!-- ACTIONS RELATIVES AU SECOND TRAITEMENT -->
    <!--****************************************-->
    
    <!-- Dans cette partie, on regarde le résultat du premier traitement pour croiser les information avec le fichier 
        qui reference toutes les infomations sur les points généré dans le livrable 2. Le fichier GPX représente une trace de passage
        on fait donc en sorte d'éliminer au mieux les placeName qui sont la a titre de repère (ex: les placeName dans les placeName)-->

    <xsl:template match="/*[name() = 'resultPart1']" mode="phase2">
        <xsl:apply-templates select="*[name() = 'phr'] | *[name() = 'placeName']" mode="phase2"/>
    </xsl:template>

    <xsl:template match="*[name() = 'phr']" mode="phase2">
        <xsl:if test="@subtype = 'motion'">
            <xsl:apply-templates select="*[name() = 'placeName']" mode="phase2"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[name() = 'placeName']" mode="phase2">

        <!-- On utilise un variable date pour remplir la pbalise time du GPX  -->
        
        <xsl:variable name="current" as="xs:date" select="current-date()"/>
        <xsl:variable name="current-day" select="month-from-date($current)"/>
        <xsl:variable name="key" select="@key"/>
        <xsl:variable name="id" select="@xml:id"/>

        <wpt xmlns="http://www.topografix.com/GPX/1/1">
            
            <!-- On fait le lien entre la clef du fichier de lieu et du placeName
                et on regarde si oui ou non un barycentre existe pour etre plus précis 
                quand il s'agit de "way" -->
            
            <xsl:choose>
                
                <!-- Si barycentre, on recupère les infos du barycentre sinon, on prend un point du lieu -->
                <xsl:when test="$adresseDocumentLieux//Lieu[@key = $key]/barycentre">
                    <xsl:attribute name="lat">
                        <xsl:value-of
                            select="$adresseDocumentLieux//Lieu[@key = $key]/barycentre/point/@latitude"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="lon">
                        <xsl:value-of
                            select="$adresseDocumentLieux//Lieu[@key = $key]/barycentre/point/@longitude"
                        />
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="lat">
                        <xsl:value-of
                            select="$adresseDocumentLieux//Lieu[@key = $key]/point/@latitude"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="lon">
                        <xsl:value-of
                            select="$adresseDocumentLieux//Lieu[@key = $key]/point/@longitude"
                        />
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- On regarde si une information sur l'altitude est disponible ou non -->
            <xsl:if test="$adresseDocumentLieux//Lieu[@key = $key]/point/@altitude">
                <ele>
                    <xsl:value-of
                        select="$adresseDocumentLieux//Lieu[@key = $key]/point/@altitude"/>
                </ele>
            </xsl:if>
            
            <!-- On gère la balise time en fonction de l'id. L'heure et la date sont la meme sauf au niveau
                des millisecondes. Ainsi, les lieux peuvent etre classifiés dans le temps pour
                avoir un ordre. Seul limitation, il n'y a que 1000 millisecondes, donc impossible d'avoir plus de 1000 points 
                dans notre texte -->
            
            <time>
                <xsl:value-of select="year-from-date($current)"/>-<xsl:if test="10 > $current-day"
                    >0</xsl:if><xsl:value-of select="month-from-date($current)"/>-<xsl:value-of
                    select="day-from-date($current)"/>T08:41:51.<xsl:value-of
                    select="replace($id, 'ene.', '')"/>+02:00
            </time>
            
            <!-- On crée la balise name de la meme facon que les balises précédentes -->
            
            <name>
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
            </name>
        </wpt>
    </xsl:template>

</xsl:stylesheet>
