<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xl="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xl"
    version="2.0">
    
    <xsl:output method="xml"/>  
    
    <xsl:template match="xl:w|xl:pc|xl:s">       
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="./xl:w|./xl:pc|./xl:s"/>
            <xsl:apply-templates/> 
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>