<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
  <!--
      xsl:copy-of Coverage Test Case
  -->
  <xsl:template match="xsl-copy-of">
    <root>
      <node type="copy-of">
        <xsl:copy-of select="*" />
      </node>
    </root>
  </xsl:template>
</xsl:stylesheet>