<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ex="x-urn:example:xproc"
    exclude-result-prefixes="#all"
    version="3.0">
    <xsl:template match="/" expand-text="yes">
        <xsl:sequence select="ex:process(.)?result"/>
    </xsl:template>
</xsl:stylesheet>