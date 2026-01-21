<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/ns/xproc"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">

   <xsl:template name="x:try-catch" as="element(p:try)">
      <xsl:context-item use="absent" />

      <xsl:param name="instruction" as="element()+" required="yes" />

      <try>
         <xsl:sequence select="$instruction" />
         <catch name="catch">
            <identity>
               <with-input pipe="error@catch"/>
            </identity>
            <!-- Put error information document in map with key 'err' -->
            <identity>
               <with-input select="map{{{{'err': .}}}}"/>
            </identity>
         </catch>
      </try>
   </xsl:template>
   

</xsl:stylesheet>