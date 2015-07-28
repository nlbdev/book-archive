<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0"
    xmlns:d="http://www.daisy.org/ns/pipeline/data" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:opf="http://www.idpf.org/2007/opf">

    <xsl:template match="/*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:choose>
                <xsl:when test="//d:file[lower-case(tokenize(@href,'/')[last()])='ncc.html']">
                    <xsl:call-template name="daisy2"/>
                </xsl:when>
                <xsl:when test="//d:file[ends-with(lower-case(@href),'.opf')] and //d:file[ends-with(lower-case(@href),'.xhtml')]">
                    <!--<xsl:call-template name="epub3"/>-->
                    <xsl:call-template name="mp3"/>
                </xsl:when>
                <xsl:when test="//d:file[ends-with(lower-case(@href),'.ncx')]">
                    <!--<xsl:call-template name="daisy3"/>-->
                    <xsl:call-template name="mp3"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="mp3"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="daisy2">
        <xsl:attribute name="format" select="'DAISY 2.02'"/>

        <xsl:variable name="document" select="/"/>

        <xsl:variable name="ncc-href" select="//d:file[lower-case(tokenize(@href,'/')[last()])='ncc.html']/@href"/>
        <xsl:variable name="ncc" select="doc($ncc-href)"/>
        <xsl:variable name="smil-hrefs" select="distinct-values($ncc//html:a/substring-before(@href,'#'))[ends-with(lower-case(.),'.smil')]"/>
        <xsl:variable name="mp3" as="xs:string*">
            <xsl:for-each select="$smil-hrefs">
                <xsl:variable name="smil-href" select="($document//d:file[matches(@href,concat('(^|/)',current()))])[1]/@href"/>
                <xsl:variable name="smil" select="doc($smil-href)"/>
                <xsl:sequence select="distinct-values($smil//*[local-name()='audio']/@src)"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="distinct-values($mp3)">
            <d:file href="{($document//d:file[matches(@href,concat('(^|/)',current()))])[1]/@href}"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="epub3">
        <xsl:attribute name="format" select="'EPUB3'"/>
        <!-- TODO -->
    </xsl:template>

    <xsl:template name="daisy3">
        <xsl:attribute name="format" select="'DAISY 3'"/>
        <!-- TODO -->
    </xsl:template>

    <xsl:template name="mp3">
        <xsl:attribute name="format" select="'MP3'"/>

        <xsl:for-each select="//d:file[ends-with(lower-case(@href),'.mp3')]">
            <xsl:sort select="@href"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
