<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <!-- Réalisé par Gnebehi Bagre -->
    
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/"> <!-- dès qu'on rencontre la racine -->
        
        <kml xmlns:atom="http://www.w3.org/2005/Atom" 
             xmlns="http://www.opengis.net/kml/2.2" 
             xmlns:gx="http://www.google.com/kml/ext/2.2" 
             xmlns:kml="http://www.opengis.net/kml/2.2"> <!-- prologue kml -->
            
            <!-- liste des placemark --> 
            <Document> 
                <xsl:for-each select="/liste/Lieu"> <!-- pour chaque lieu -->
                    <Placemark> <!-- on place un marqueur -->
                        <name> <!-- TITRE -->
                            <xsl:value-of select="./point/@name"/>
                        </name>
                        <description> <!-- DESCRIPTION -->
                            <xsl:text>&#xA;<!-- retour chariot --></xsl:text>
                            <xsl:text>ID :</xsl:text>
                            <xsl:text>&#xA;<!-- retour chariot --></xsl:text>
                            <xsl:value-of select="@id"/>
                            <xsl:text>&#xA;<!-- retour chariot --></xsl:text>
                            <xsl:text>&#xA;<!-- retour chariot --></xsl:text>
                            <xsl:text>LIEN :</xsl:text>
                            <xsl:text>&#xA;<!-- retour chariot --></xsl:text>
                            <xsl:value-of select="@lien"/>
                            <xsl:text>&#xA;<!-- retour chariot --></xsl:text>
                            <xsl:text>&#xA;<!-- retour chariot --></xsl:text>
                            <xsl:text>KEY :</xsl:text>
                            <xsl:text>&#xA;<!-- retour chariot --></xsl:text>
                            <xsl:value-of select="@key"/>
                            <xsl:text>&#xA;<!-- retour chariot --></xsl:text>
                            <xsl:text>&#xA;<!-- retour chariot --></xsl:text>
                            
                            <xsl:for-each select="./document"> <!-- pour chaque document -->     
                                <xsl:text>DOCUMENT :</xsl:text>
                                <xsl:text>&#xA;<!-- retour chariot --></xsl:text>
                                <xsl:value-of select="@docOrigine"/>
                                <xsl:text>&#xA;<!-- retour chariot --></xsl:text>
                                <xsl:text>&#xA;<!-- retour chariot --></xsl:text>
                                
                                <xsl:for-each select="./idOrigine"> <!-- pour chaque idOrigine -->
                                    <xsl:text>ID_ORIGINE :</xsl:text>
                                    <xsl:text>&#xA;<!-- retour chariot --></xsl:text>
                                    <xsl:value-of select="@idOrigine"/>
                                    <xsl:text>&#xA;<!-- retour chariot --></xsl:text>
                                    <xsl:text>&#xA;<!-- retour chariot --></xsl:text>
                                </xsl:for-each>
                      
                            </xsl:for-each>

                        </description>

                        
                        <Point>

                                   <coordinates> <!-- COORDONNEES -->
                                       <xsl:if test="./barycentre">
                                           <xsl:value-of select="./barycentre/point/@longitude"/>
                                           <xsl:text>,</xsl:text>
                                           <xsl:value-of select="./barycentre/point/@latitude"/>  
                                       </xsl:if>
                                       <xsl:if test="not(./barycentre)">
                                           <xsl:value-of select="./point/@longitude"/>
                                           <xsl:text>,</xsl:text>
                                           <xsl:value-of select="./point/@latitude"/> 
                                       </xsl:if>
                                       
                                                                                   
                                   </coordinates>
                                   
                               
                            
                            
                        </Point>
                    </Placemark>
                </xsl:for-each>
            </Document>
            
        </kml>
        
    </xsl:template>
    
</xsl:stylesheet>