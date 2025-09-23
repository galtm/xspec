<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
   xmlns:ex="x-urn:example:xproc" xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
   version="3.1">

   <p:import href="my-xproc-step.xpl"/>
   <p:import href="../../../src/xproc3/run-xslt.xpl"/>
   <p:output port="result"/>
<!--   <xspec:run-xslt>
      <p:with-input href="test-xproc-step.xspec"/>
      <p:with-option name="xspec-home" select="resolve-uri('../../../')"/>
      <p:with-option name="parameters" select="map{'log-compilation': resolve-uri('compiled.xsl')}"/>
   </xspec:run-xslt>
-->
   
   <p:xslt template-name="xspec:main">
      <p:with-input port="source"><p:empty/></p:with-input>
      <p:with-input port="stylesheet" href="compiled-import.xsl"/>
   </p:xslt>
</p:declare-step>
