<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">
    <xsl:template match="/">
        <xsl:variable name="transformOptions" as="map(*)">
            <xsl:map>
                <xsl:map-entry key="'stylesheet-location'"
                    select="resolve-uri('pception.xsl')"/>
                <xsl:map-entry key="'source-node'" select="doc('doc.xml')"/>
            </xsl:map>
        </xsl:variable>
        <xsl:sequence select="transform($transformOptions)?output"/>
    </xsl:template>
</xsl:stylesheet>