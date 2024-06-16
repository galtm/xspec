<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
  <!--
      xsl:for-each Coverage Test Case
  -->
  <xsl:template match="xsl-for-each">
    <root>
      <!-- Simple for-each -->
      <xsl:for-each select="1 to 5">
        <node type="for-each">
          <xsl:value-of select=". * 100" />
        </node>
      </xsl:for-each>
      <!-- Missed for-each -->
      <xsl:for-each select="()">                                               <!-- Expected miss -->
        <xsl:message terminate="yes" />                                        <!-- Expected miss -->
      </xsl:for-each>                                                          <!-- Expected miss -->
    </root>
  </xsl:template>
</xsl:stylesheet>