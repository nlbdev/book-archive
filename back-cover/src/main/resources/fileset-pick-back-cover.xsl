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
        <xsl:for-each select="$ncc//html:*[matches(local-name(),'^h\d') and .//html:a]">
            <xsl:variable name="text" select="lower-case(string-join(.//text(),''))"/>
            <xsl:if test="contains($text,'bokomtale') or contains($text, 'baksidetekst') or contains($text, 'omslagstekst')">
                <xsl:variable name="smil-href" select="resolve-uri((.//html:a)[1]/substring-before(@href,'#'), base-uri())"/>
                <xsl:variable name="smil-id" select="(.//html:a)[1]/substring-after(@href,'#')"/>
                <xsl:variable name="smil" select="doc($smil-href)"/>
                <xsl:variable name="audio-href" select="$smil//*[@id=$smil-id]/(ancestor-or-self::*[local-name()='par']//*[local-name()='audio'])[1]/resolve-uri(@src,base-uri())"/>
                <d:file href="{$audio-href}"/>
            </xsl:if>
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

        <xsl:for-each select="//d:file[
                                        contains(lower-case(@href),'bokomtale') or
                                        contains(lower-case(@href),'baksidete') or
                                        contains(lower-case(@href),'omslagste')
                                      ]">
            <xsl:sort select="@href"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
