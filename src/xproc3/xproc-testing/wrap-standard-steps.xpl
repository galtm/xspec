<?xml version="1.0" encoding="UTF-8"?>
<p:library xmlns:ps="http://www.jenitennison.com/xslt/xspec/xproc/steps/wrap-standard-steps"
    xmlns:p="http://www.w3.org/ns/xproc" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="3.0">

    <!--
        This library provides wrappers around selected standard XProc steps
        so that an XPath expression in an XSpec test can use the functionality
        via step functions.

        Example:

        <x:variable name="options-for-load" as="map(*)"
            select="map{'href': 'document-not-xhtml.html' => resolve-uri($x:xspec-uri)}"/>
        <x:call step="s:get-html-description">
            <x:input port="source" select="ps:load($options-for-load)?result"/>
        </x:call>
    -->

    <p:declare-step type="ps:load" name="load">
        <p:output port="result" sequence="true" content-types="any"/>
        <p:option name="href" required="true" as="xs:anyURI"/>
        <p:option name="parameters" as="map(xs:QName,item()*)?"/>
        <p:option name="content-type" as="xs:string?"/>
        <p:option name="document-properties" as="map(xs:QName, item()*)?"/>
        <p:load>
            <p:with-option name="href" select="$href"/>
            <p:with-option name="parameters" select="$parameters"/>
            <p:with-option name="content-type" select="$content-type"/>
            <p:with-option name="document-properties" select="$document-properties"/>
        </p:load>
    </p:declare-step>

    <p:declare-step type="ps:cast-content-type" name="cast-content-type">
        <p:input port="source" content-types="any"/>
        <p:output port="result" content-types="any"/>
        <p:option name="content-type" required="true" as="xs:string"/>
        <p:option name="parameters" as="map(xs:QName,item()*)?"/>
        <p:cast-content-type>
            <p:with-option name="content-type" select="$content-type"/>
            <p:with-option name="parameters" select="$parameters"/>
        </p:cast-content-type>
    </p:declare-step>

</p:library>
