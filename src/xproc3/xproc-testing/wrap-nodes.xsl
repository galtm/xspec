<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:test-helper="http://www.jenitennison.com/xslt/xspec/xproc/helpers/wrap-nodes" version="3.0">

    <!-- test-helper:wrap-each individually wraps each node in $nodes in a document node. -->
    <xsl:function name="test-helper:wrap-each" as="document-node()*">
        <xsl:param name="nodes" as="node()*"/>
        <xsl:for-each select="$nodes">
            <xsl:sequence select="test-helper:wrap-all(.)"/>
        </xsl:for-each>
    </xsl:function>

    <!-- test-helper:wrap-all wraps all nodes in $nodes in a single document node. -->
    <!-- The body of test-helper:wrap-all is a copy of wrap:wrap-nodes in src/common/wrap/xsl.
        The reason for making a copy is that wrap.xsl is not user-facing. If needed, this function
        can adapt to user needs without affecting wrap.xsl. -->
    <xsl:function name="test-helper:wrap-all" as="document-node()">
        <xsl:param name="nodes" as="node()*"/>

        <!-- $wrap aims to create an implicit document node as described
         in https://www.w3.org/TR/xslt-30/#temporary-trees.
         So its xsl:variable must not have @as or @select.
         Do not use xsl:document or xsl:copy-of: xspec/xspec#47 -->
        <xsl:variable name="wrap">
            <xsl:sequence select="$nodes"/>
        </xsl:variable>
        <xsl:sequence select="$wrap"/>
    </xsl:function>

</xsl:stylesheet>