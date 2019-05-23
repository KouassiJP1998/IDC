<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"></xsl:output>
    
    <xsl:template match="/">
        
        <!-- On créer une variable qui applique un premier traitement sur un fichier xml afin de récupérer les lieux "correctes" de la trace -->
        
        <xsl:variable name="resultPart1">
            <resultPart1>
                <xsl:apply-templates select="node() | @*" mode="phase1"/>
            </resultPart1>
        </xsl:variable>
        
        <ListNomPropre>
            <xsl:apply-templates mode="phase2" select="$resultPart1"/>
        </ListNomPropre>
        
    </xsl:template>
    
    
    <xsl:template mode="phase1" match="node() | @*">
        
        <ListNomPropre>
            <xsl:call-template  name="getNPr"></xsl:call-template>
        </ListNomPropre>
    </xsl:template>
    
    <xsl:template  name="getNPr">
        <xsl:variable name="text" select="unparsed-text('./usefull/au_depart_de_merrien.txt', 'utf-8')"></xsl:variable>
        
        <xsl:copy>
            
            <xsl:analyze-string select="$text" regex="(([A-Z]+[a-zé|è|à|ù]*[0-9]*(-(([A-Z]+[a-zé|è|à|ù]*[0-9]*))|\s(([A-Z]+[a-zé|è|à|ù]*[0-9]*)))*))">
                <xsl:matching-substring>                      
                    <xsl:element name="Npr">
                        <xsl:attribute name="nom">
                            <xsl:value-of select="."/>
                        </xsl:attribute> 
                        
                    </xsl:element> 
                    
                </xsl:matching-substring>
                
                <xsl:non-matching-substring>
                    
                    <xsl:analyze-string select="." regex="\.|\n">
                        
                        <xsl:matching-substring>                      
                            <xsl:element name="Ponc">
                            </xsl:element>                           
                        </xsl:matching-substring>
                        
                    </xsl:analyze-string>
                    
                </xsl:non-matching-substring>
            </xsl:analyze-string>   
        </xsl:copy>   
        
    </xsl:template>
    
    <xsl:template match="*[name()='Npr']" mode="phase2">    
        
        <xsl:variable name="recupAll" select="preceding-sibling::node()"/>
        <xsl:variable name="recupLast" select="$recupAll[last()]"/>
        
        <xsl:if test="$recupLast/name() = 'Npr'">
            <xsl:element name="{local-name()}">
                <xsl:copy-of select="node()|@*"></xsl:copy-of>
            </xsl:element>
        </xsl:if>
        
    </xsl:template>
    
</xsl:stylesheet>