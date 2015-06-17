<?xml version="1.0" encoding="utf-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:cx="http://xmlcalabash.com/ns/extensions" version="1.0">

    <p:option name="book-dir" select="'file:/book/'"/>
    <p:option name="abstract-dir" select="'file:/abstract/'"/>

    <p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>

    <p:directory-list>
        <p:with-option name="path" select="$book-dir"/>
    </p:directory-list>
    <cx:message>
        <p:with-option name="message" select="concat('The contents of the book directory is: ', string-join(/*/*/@name, ', '))"/>
    </cx:message>
    <p:sink/>
    
    <!-- TODO: some logic here to pick out a mp3 file appropriate for making an abstract -->
    
    <!-- TODO: make a copy of the mp3 file in file:/abstract/ and cut it using p:exec and probably mp3splt -->

</p:declare-step>
