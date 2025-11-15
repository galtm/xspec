<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:local="urn:x-xspec:compiler:xproc:compile:compute-position:local"
    xmlns:p="http://www.w3.org/ns/xproc" xmlns:x="http://www.jenitennison.com/xslt/xspec"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all">

    <!-- Call x:input-position to get @position for an x:call[@step]/x:input element -->
    <xsl:function name="x:input-position" as="xs:integer">
        <xsl:param name="x-input" as="element(x:input)"/>
        <xsl:variable name="port-name" as="xs:string" select="$x-input/@name"/>
        <xsl:variable name="step-port-lookup" as="xs:string"
            select="$port-name || '@' || local:step-type($x-input)"/>
        <xsl:variable name="port-def" as="element(p:input)?"
            select="key('step-inputs', $step-port-lookup, $xproc-tree)[1]"/>
        <xsl:choose>
            <xsl:when test="exists($port-def)">
                <xsl:variable name="ports-to-this-point" as="element(p:input)+"
                    select="($port-def, $port-def/preceding-sibling::p:input)"/>
                <xsl:sequence select="count($ports-to-this-point)"/>
                <xsl:if test="exists($ports-to-this-point/@use-when) and empty($x-input/preceding-sibling::x:input)">
                    <xsl:variable name="use-when-warning" as="xs:string" expand-text="yes">Calling step {
                        local:step-type($x-input)} assumes each p:input/@use-when is true.</xsl:variable>
                    <xsl:message>
                        <xsl:for-each select="$x-input">
                            <xsl:call-template name="x:prefix-diag-message">
                                <xsl:with-param name="level" select="'WARNING'" />
                                <xsl:with-param name="message" select="$use-when-warning" />
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:message>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes" expand-text="yes">Cannot find input port '{
                    $port-name}' in step {local:step-type($x-input)}</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- Global variables -->
    <xsl:variable name="xproc-doc" as="document-node()"
        select="$initial-document/x:description/@xproc ! resolve-uri(string(.), base-uri(.)) => doc()"/>
    <xsl:variable name="xproc-tree" as="document-node()">
        <xsl:apply-templates select="$xproc-doc" mode="local:gather-steps"/>
    </xsl:variable>

    <!-- Keys -->
    <xsl:key name="step-inputs" match="p:declare-step[@type]/p:input"
        use="string(@port) || '@' || string(../@type)"/>

    <!-- local:gather-steps mode -->
    <xsl:mode name="local:gather-steps" on-no-match="shallow-skip"/>
    <xsl:template match="document-node()" mode="local:gather-steps" as="document-node()">
        <xsl:param name="import-stack" tunnel="yes" select="base-uri()" as="xs:anyURI*"/>
        <xsl:document>
            <xsl:apply-templates mode="#current">
                <xsl:with-param name="import-stack" tunnel="yes" select="$import-stack"/>
            </xsl:apply-templates>
        </xsl:document>
    </xsl:template>
    <xsl:template match="/p:library" mode="local:gather-steps">
        <xsl:copy>
            <xsl:apply-templates select="(p:declare-step[@type], p:import)" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="p:declare-step" mode="local:gather-steps">
        <xsl:copy>
            <xsl:attribute name="type" select="local:UQName-of-step(./@type)"/>
            <xsl:apply-templates select="p:input" mode="#current"/>
        </xsl:copy>
        <xsl:apply-templates select="p:import" mode="#current"/>
    </xsl:template>
    <xsl:template match="p:input" mode="local:gather-steps">
        <xsl:copy>
            <xsl:sequence select="@port | @use-when"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="p:import[@href]" mode="local:gather-steps">
        <xsl:param name="import-stack" tunnel="yes" required="yes" as="xs:anyURI*"/>
        <!-- We might import the same pipeline multiple times, but non-circular duplication doesn't
        matter for later processing. We could remove duplicates by imitating the compiler's
        x:gather-descriptions function, but the processing seems to take longer. -->
        <xsl:variable name="resolved-href" as="xs:anyURI?" select="@href => resolve-uri(base-uri())"/>
        <xsl:if test="not($resolved-href = $import-stack)">
            <xsl:apply-templates select="$resolved-href => doc()" mode="#current">
                <xsl:with-param name="import-stack" tunnel="yes"
                    select="($resolved-href, $import-stack)"/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

    <xsl:function name="local:UQName-of-step" as="xs:string">
        <xsl:param name="attr" as="attribute()"/>
        <!-- $attr is p:declare-step/@type or x:call/@step -->
        <xsl:choose>
            <xsl:when test="contains($attr, ':')">
                <xsl:sequence select="x:UQName-from-EQName-ignoring-default-ns($attr, $attr/..)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$attr/string()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="local:step-type" as="xs:string">
        <xsl:param name="element" as="element(x:input)"/>
        <xsl:sequence select="$element/parent::x:call/@step => local:UQName-of-step()"/>
    </xsl:function>

</xsl:stylesheet>
