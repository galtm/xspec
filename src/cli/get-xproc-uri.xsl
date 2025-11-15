<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:x="http://www.jenitennison.com/xslt/xspec"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="#all" version="3.0">
    <xsl:output method="text"/>
    <xsl:import href="../common/uri-utils.xsl"/>
    <xsl:template name="xsl:initial-template" as="text()">
        <!-- Resolve @xproc to get actual base URI -->
        <xsl:value-of select="
                /x:description/@xproc
                => resolve-uri(base-uri())
                => x:resolve-xml-uri-with-catalog()"/>
    </xsl:template>
</xsl:stylesheet>
