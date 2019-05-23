<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <gpx xmlns="http://www.topografix.com/GPX/1/1" creator="byHand" version="1.1"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">
            <xsl:apply-templates select="node() | @*"/>
        </gpx>
    </xsl:template>

    <xsl:template match="*[name() = 'text']/*[name() = 'body']/*[name() = 'p']">
        <xsl:apply-templates select="*[name() = 'phr'] | *[name() = 'placeName']"/>
    </xsl:template>

    <xsl:template match="*[name() = 'phr']">
        <xsl:if test="@subtype = 'motion'">
            <xsl:apply-templates select="*[name() = 'placeName']"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[name() = 'placeName']">

        <xsl:variable name="current" as="xs:date" select="current-date()"/>
        <xsl:variable name="current-day" select="month-from-date($current)"/>
        <xsl:variable name="key" select="@key"/>
        <xsl:variable name="id" select="@xml:id"/>

        <wpt xmlns="http://www.topografix.com/GPX/1/1">
            <xsl:choose>
                <xsl:when test="document('../listeLieux2.xml')//Lieu[@key = $key]/barycentre">
                    <xsl:attribute name="lat">
                        <xsl:value-of
                            select="document('../listeLieux2.xml')//Lieu[@key = $key]/barycentre/point/@latitude"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="lon">
                        <xsl:value-of
                            select="document('../listeLieux2.xml')//Lieu[@key = $key]/barycentre/point/@longitude"
                        />
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="lat">
                        <xsl:value-of
                            select="document('../listeLieux2.xml')//Lieu[@key = $key]/point/@latitude"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="lon">
                        <xsl:value-of
                            select="document('../listeLieux2.xml')//Lieu[@key = $key]/point/@longitude"
                        />
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:if test="document('../listeLieux2.xml')//Lieu[@key = $key]/point/@altitude">
                <ele>
                    <xsl:value-of
                        select="document('../listeLieux2.xml')//Lieu[@key = $key]/point/@altitude"/>
                </ele>
            </xsl:if>

            <!--  <xsl:variable name="pos" select="position()"/><xsl:value-of select="$OtherSource[$pos]"/>-->

            <time>
                <xsl:value-of select="year-from-date($current)"/>-<xsl:if test="10 > $current-day"
                    >0</xsl:if><xsl:value-of select="month-from-date($current)"/>-<xsl:value-of
                    select="day-from-date($current)"/>T08:41:51.<xsl:value-of
                    select="replace($id, 'ene.', '')"/>+02:00</time>
            <name>
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
            </name>
        </wpt>
    </xsl:template>


</xsl:stylesheet>
