<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:h="http://www.w3.org/1999/xhtml" xmlns:x="http://www.jenitennison.com/xslt/xspec"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map" name="run-xproc-cases"
    type="x:run-xproc-cases" version="3.1">

    <p:documentation>
        <p>This pipeline executes all .xspec files in the cases directory.</p>
        <p><b>Input ports:</b> None.</p>
        <p><b>Output ports:</b> None. This pipeline raises an error if any tests fail.</p>
    </p:documentation>

    <p:import href="../../src/xproc3/xproc-testing/run-xproc.xpl"/>

    <p:option name="debugmode" as="xs:boolean" select="false()" static="true"/>
    <p:option name="xspec-home" as="xs:string" select="resolve-uri('../../')"/>
    <p:option name="parameters" as="map(xs:QName,item()*)" select="map{}"/>

    <p:option name="cases-dir" as="xs:anyURI" select="resolve-uri('cases/')"/>

    <p:directory-list path="{$cases-dir}" max-depth="1" include-filter="\.xspec$"/>
    <p:variable name="case-count" select="count(//c:file)"/>

    <p:for-each message="Found {$case-count} test cases.">
        <p:with-input select="//c:file"/>
        <p:variable name="test-filename" select="/*/@name"/>
        <p:load href="{$cases-dir}{$test-filename}" name="test-file"/>
        <p:for-each>
            <p:with-input select="/x:description"/>

            <p:identity message="&#10;--- Running { $test-filename } ---" name="msg"/>
            <x:run-xproc p:depends="msg">
                <p:with-input pipe="result@test-file"/>
                <p:with-option name="xspec-home" select="$xspec-home"/>
            </x:run-xproc>
            <p:store href="{$cases-dir}/results/{$test-filename}.html" use-when="$debugmode"/>

            <p:xslt name="check-html-report">
                <p:with-input port="stylesheet">
                    <p:inline>
                        <xsl:stylesheet version="3.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                            xmlns:h="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all">
                            <xsl:mode on-no-match="shallow-skip"/>
                            <xsl:template match="/">
                                <!-- $failure-text should be 'failed:&#160;' followed by the number of failures -->
                                <xsl:variable name="failure-text" as="xs:string"
                                    select="exactly-one(descendant::h:th[contains-token(@class, 'emphasis')])/string()"/>
                                <xsl:variable name="xspec-file" as="xs:string"
                                    select="exactly-one(//h:body/h:p/text()[.='XSpec: ']/following-sibling::h:a)/string()"/>
                                <xsl:if test="replace($failure-text, '^failed:&#160;','') ne '0'">
                                    <message>
                                        <xsl:value-of select="concat($xspec-file, ' ', $failure-text)"/>
                                    </message>
                                </xsl:if>
                                <!-- Checking header for each report, instead of only one, is
                                    redundant. Should the next xsl:if be removed? -->
                                <xsl:if test="empty(//h:body/h:p/text()[.='XProc: '])">
                                    <message>
                                        <xsl:value-of
                                            select="concat($xspec-file, ' report header does not indicate XProc pipeline being tested')"
                                        />
                                    </message>
                                </xsl:if>
                            </xsl:template>
                        </xsl:stylesheet>
                    </p:inline>
                </p:with-input>
            </p:xslt>
        </p:for-each>
    </p:for-each>
    <p:wrap-sequence>
        <p:with-option name="wrapper" select="QName('','messages')"/>
    </p:wrap-sequence>
    <p:if test="string-length(.) gt 0">
        <p:error code="x:TEST-EVENT-XPROC-001"/>
    </p:if>
    <p:identity message="&#10;--- Testing completed with no failures! ---&#10;"/>
    <p:sink/>
</p:declare-step>
