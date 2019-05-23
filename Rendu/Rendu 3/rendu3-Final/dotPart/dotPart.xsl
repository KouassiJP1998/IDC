<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <!-- GPX Transformation, Stanislas PEDEBEARN -->
    <!-- Parse un fichier xml comme "fr_pralognan.xml" en fichier GPX. Le résultat est lisible avec tout lecteur de gpx -->
    
    <xsl:output method="text" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="adresseDocumentLieux" select="document('./../usefull/listeLieux.xml')"/>
    
    <!--****************************************-->
    <!--      COMBINAISON DES TRAITEMENTS       -->
    <!--****************************************-->
    
    <xsl:template match="/">
        
        <!-- On créer une variable qui applique un premier traitement sur un fichier xml afin de récupérer les lieux "correctes" de la trace -->
        
        
        <xsl:variable name="resultPart1">
            <resultPart1>
                <xsl:apply-templates select="node() | @*" mode="phase1"/>
            </resultPart1>
        </xsl:variable>
        
        
        <!-- La variable est un arbre balisé auquel on applique un second traitement pour transfomer le tout en fichier GPX -->
       <xsl:variable name="resultPart2"> 
            <resultPart2>
                <xsl:apply-templates mode="phase2" select="$resultPart1"/>
            </resultPart2>
        </xsl:variable>

        <xsl:apply-templates mode="phase3" select="$resultPart2"/>
        
    </xsl:template>
    
    
    <!--****************************************-->
    <!-- ACTIONS RELATIVES AU PREMIER TRAITEMENT-->
    <!--****************************************-->
    
    <!-- Dans cette partie, on ne garde que les phr et les placeName qui peuvent fournir des infos de géolocalisation -->
    
    <xsl:template match="*[name()='text']/*[name()='body']/*[name()='p']/*[name()='s']" mode="phase1">
        <xsl:apply-templates select="*[name()='phr'] | *[name()='placeName']" mode="phase1"/>
    </xsl:template>
    
    <xsl:template match="*[name()='phr']" mode="phase1">
        
        <xsl:if test=".//*[name()='placeName' and @key]">
            
            <xsl:element name="{local-name()}" xmlns="http://www.tei-c.org/ns/1.0">
                <xsl:copy-of select="@*"/>
                
                <xsl:variable name="test" select="child::node()[1]"/>
                
                <xsl:if test="child::node()[1][name()='w'] and child::node()[1]/@type = 'V'">
                    <xsl:attribute name="phrtest"><xsl:value-of select="child::node()[1]/@lemma"/></xsl:attribute>
                </xsl:if>
                
                <xsl:apply-templates select=" *[name()='placeName'] " mode="phase1"/>
            </xsl:element>
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="*[name()='placeName']" mode="phase1">
        
        <xsl:choose>
            <xsl:when test="@key">
                <xsl:element name="{local-name()}" xmlns="http://www.tei-c.org/ns/1.0">
                    <xsl:copy-of select="@* "/> 
                    <xsl:apply-templates select=" .//*[name()='placeName'] " mode="phase1"/>
                </xsl:element> 
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select=" .//*[name()='placeName'] " mode="phase1"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <!--****************************************-->
    <!-- ACTIONS RELATIVES AU SECOND TRAITEMENT-->
    <!--****************************************-->

    <xsl:template match="/*[name() = 'resultPart1']" mode="phase2">
        <liste>
            <xsl:apply-templates select="*[name() = 'phr'] | *[name() = 'placeName']" mode="phase2"/>
        </liste>
    </xsl:template>
    
    <xsl:template match="*[name() = 'phr']" mode="phase2">
        <xsl:if test="@subtype = 'motion'">
            <xsl:apply-templates select="*[name() = 'placeName']" mode="phase2"/>
        </xsl:if>
        <xsl:if test="@subtype = 'perception'" >
            <xsl:apply-templates select="*[name() = 'placeName']"  mode="viewInPhr"/>
        </xsl:if>       
    </xsl:template>
    
    <!-- PlaceName seul et dans phr-->
    
    <xsl:template match="*[name() = 'placeName']" mode="phase2">
        
        <xsl:variable name="id" select="substring-after(@xml:id,'.')"/>
        <xsl:variable name="key" select="@key"/>
        <xsl:variable name="contextInfo" select="following::node()"/>
        <xsl:variable name="nextPlaceName" select="following::*//@xml:id"/>
        
        <lieu>
            <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
            <xsl:attribute name="name">
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
            </xsl:attribute>
            
            <direct-edge>   
                
                <!-- Récupération du placeName premier placeName suivant en regardant si il est dans un phr de type view ou non-->
                <xsl:choose>
                    <xsl:when test="($contextInfo[1]/name() = 'phr' and $contextInfo[1]/@subtype = 'motion') or $contextInfo[1]/name() = 'placeName'">
                        <xsl:if test="$contextInfo[1]/@phrtest">
                            <xsl:attribute name="info"><xsl:value-of select="$contextInfo[1]/@phrtest"/></xsl:attribute>    
                        </xsl:if>
                        
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
                    <infoPlace><xsl:attribute name="id"><xsl:value-of select="$contextInfo[2]/substring-after(@xml:id,'.')"/></xsl:attribute>
                        <xsl:if test="$contextInfo[1]/@phrtest">
                            <xsl:attribute name="info"><xsl:value-of select="$contextInfo[1]/@phrtest"/></xsl:attribute>
                        </xsl:if></infoPlace>
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
            </xsl:attribute>
        </lieu>  
    </xsl:template>
    
    
    <!--****************************************-->
    <!-- ACTIONS RELATIVES AU TROISIEME TRAITEMENT-->
    <!--****************************************-->
    
    <xsl:template match="/*[name() = 'resultPart2']" mode="phase3">
        digraph {
        <xsl:apply-templates select="node()|@*" mode="etape1"/>
        <xsl:apply-templates select="node()|@*" mode="etape2"/>
        }
    </xsl:template>
    
    <xsl:template match="*[name() = 'liste']/*[name()='lieu']" mode="etape1">
        <xsl:value-of select="@id"/> [label="<xsl:value-of select="@name"/>"]
        <xsl:choose>
            <xsl:when test="not(direct-edge/@id)">
                [shape=box];
            </xsl:when>
            <xsl:otherwise>
                ;
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="*[name() = 'liste']/*[name()='lieu']" mode="etape2"> 
        
        <xsl:if test="direct-edge/@id !=''">
            <xsl:value-of select="@id"/> -> <xsl:value-of select="direct-edge/@id"/><xsl:if test="direct-edge/@info">[label= <xsl:value-of select="direct-edge/@info"/> fontcolor=cadetblue]</xsl:if>;   
        </xsl:if>
        
        <xsl:apply-templates select="*[name() = 'infoPlace']" mode="phase3"/>
    </xsl:template>
    
    
    <xsl:template match="*[name() = 'infoPlace']" mode="phase3">       
        <xsl:if test="@id !=''">
            <xsl:value-of select="parent::node()/@id"/> -> <xsl:value-of select="@id"/> [style=dotted dir=none]<xsl:if test="@info">[label= <xsl:value-of select="@info"/> fontcolor=cadetblue]</xsl:if>;  
        </xsl:if>    
    </xsl:template>
    
</xsl:stylesheet>