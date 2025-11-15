<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:x="http://www.jenitennison.com/xslt/xspec" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-inline-prefixes="#all" name="run-xproc-error-cases" type="x:run-xproc-error-cases"
    version="3.1">

    <p:documentation>
        <p>This pipeline executes all .xspec files in the error-cases directory.</p>
        <p><b>Input ports:</b> None.</p>
        <p><b>Output ports:</b> None. This pipeline raises an error if any tests do not catch an
            error.</p>
    </p:documentation>

    <p:import href="../../src/xproc3/xproc-testing/run-xproc.xpl"/>

    <p:option name="debugmode" as="xs:boolean" select="false()" static="true"/>
    <p:option name="xspec-home" as="xs:string" select="resolve-uri('../../')"/>
    <p:option name="parameters" as="map(xs:QName,item()*)" select="map{}"/>

    <p:option name="cases-dir" as="xs:anyURI" select="resolve-uri('error-cases/')"/>

    <p:directory-list path="{$cases-dir}" max-depth="1" include-filter="\.xspec$"/>
    <p:variable name="case-count" select="count(//c:file)"/>

    <p:for-each message="Found {$case-count} test cases.">
        <p:with-input select="//c:file"/>
        <p:variable name="test-filename" select="/*/@name"/>
        <p:load href="{$cases-dir}{$test-filename}" name="test-file"/>
        <p:for-each>
            <p:with-input select="/x:description"/>

            <p:identity message="--- Running { $test-filename } ---" name="msg"/>
            <p:try>
                <p:group>
                    <x:run-xproc p:depends="msg">
                        <p:with-input pipe="result@test-file"/>
                        <p:with-option name="xspec-home" select="$xspec-home"/>
                    </x:run-xproc>
                    <p:identity>
                        <p:with-input>
                            <message>{string($test-filename)} did not raise an error.</message>
                        </p:with-input>
                    </p:identity>
                </p:group>
                <p:catch>
                    <!-- We expected an error and correctly got an error. This pipeline doesn't
                        check details of the error because the deep call stack makes that challenging.
                        For now, just move on. -->
                    <p:identity>
                        <p:with-input>
                            <p:inline/>
                        </p:with-input>
                    </p:identity>
                </p:catch>
            </p:try>
            <p:store href="{$cases-dir}/results/{$test-filename}.html" use-when="$debugmode"/>
        </p:for-each>
    </p:for-each>
    <p:wrap-sequence>
        <p:with-option name="wrapper" select="QName('','messages')"/>
    </p:wrap-sequence>
    <p:if test="string-length(.) gt 0">
        <p:error code="x:TEST-EVENT-XPROC-002"/>
    </p:if>
    <p:identity message="&#10;--- Each test raised an error, which was expected. ---&#10;"/>
    <p:sink/>
</p:declare-step>
