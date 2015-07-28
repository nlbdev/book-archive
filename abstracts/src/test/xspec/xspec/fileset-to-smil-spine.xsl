<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:test="http://www.jenitennison.com/xslt/unit-test"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                xmlns:__x="http://www.w3.org/1999/XSL/TransformAliasAlias"
                xmlns:pkg="http://expath.org/ns/pkg"
                xmlns:impl="urn:x-xspec:compile:xslt:impl"
                xmlns:d="http://www.daisy.org/ns/pipeline/data"
                version="2.0">
   <xsl:import href="file:/home/jostein/nlb/book-archive/abstracts/src/main/resources/fileset-to-smil-spine.xsl"/>
   <xsl:import href="file:/home/jostein/Oxygen%20XML%20Editor%2017/frameworks/xspec/src/compiler/generate-tests-utils.xsl"/>
   <xsl:namespace-alias stylesheet-prefix="__x" result-prefix="xsl"/>
   <xsl:variable name="x:stylesheet-uri"
                 as="xs:string"
                 select="'file:/home/jostein/nlb/book-archive/abstracts/src/main/resources/fileset-to-smil-spine.xsl'"/>
   <xsl:output name="x:report" method="xml" indent="yes"/>
   <xsl:template name="x:main">
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('xsl:product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:message>
      <xsl:result-document format="x:report">
         <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="file:/home/jostein/Oxygen%20XML%20Editor%2017/frameworks/xspec/src/compiler/format-xspec-report.xsl"</xsl:processing-instruction>
         <x:report stylesheet="{$x:stylesheet-uri}" date="{current-dateTime()}">
            <xsl:call-template name="x:d6e2"/>
            <xsl:call-template name="x:d6e26"/>
         </x:report>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="x:d6e2">
      <xsl:message>MP3</xsl:message>
      <x:scenario>
         <x:label>MP3</x:label>
         <x:context>
            <d:directory>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0001.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0002.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0006.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0005.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0004.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0007.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0003.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/tpbnarrator_res.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/subdir/audio.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/non-audio-file.txt"/>
            </d:directory>
         </x:context>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context-doc" as="document-node()">
               <xsl:document>
                  <d:directory>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0001.mp3"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0002.mp3"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0006.mp3"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0005.mp3"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0004.mp3"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0007.mp3"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0003.mp3"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/tpbnarrator_res.mp3"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/subdir/audio.mp3"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/non-audio-file.txt"/>
                  </d:directory>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="impl:context" select="$impl:context-doc/node()"/>
            <xsl:apply-templates select="$impl:context"/>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d6e15">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e15">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>The result should be the audio files in reading order</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <d:directory format="MP3">
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0001.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0002.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0003.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0004.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0005.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0006.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0007.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/subdir/audio.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/tpbnarrator_res.mp3"/>
            </d:directory>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" select="$impl:expected-doc/node()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>The result should be the audio files in reading order</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e26">
      <xsl:message>DAISY 2.02</xsl:message>
      <x:scenario>
         <x:label>DAISY 2.02</x:label>
         <x:context>
            <d:directory>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0001.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0001.smil"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/content.html"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/ncc.html"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0002.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0006.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0002.smil"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0005.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0004.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0007.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0003.smil"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0003.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/tpbnarrator_res.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/default.css"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0004.smil"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0006.smil"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0007.smil"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0005.smil"/>
            </d:directory>
         </x:context>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context-doc" as="document-node()">
               <xsl:document>
                  <d:directory>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0001.mp3"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0001.smil"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/content.html"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/ncc.html"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0002.mp3"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0006.mp3"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0002.smil"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0005.mp3"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0004.mp3"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0007.mp3"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0003.smil"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0003.mp3"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/tpbnarrator_res.mp3"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/default.css"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0004.smil"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0006.smil"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0007.smil"/>
                     <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0005.smil"/>
                  </d:directory>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="impl:context" select="$impl:context-doc/node()"/>
            <xsl:apply-templates select="$impl:context"/>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d6e48">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e48">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>The result should be the audio files in reading order, including format and duration attributes</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <d:directory format="DAISY 2.02">
               <d:file href="../../../src/test/resources/dontworrybehappy/tpbnarrator_res.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0001.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0002.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0003.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0004.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0005.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0006.mp3"/>
               <d:file href="../../../src/test/resources/dontworrybehappy/speechgen0007.mp3"/>
            </d:directory>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" select="$impl:expected-doc/node()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>The result should be the audio files in reading order, including format and duration attributes</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
</xsl:stylesheet>
