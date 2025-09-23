<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
   xmlns:ex="x-urn:example:xproc" xmlns:t="http://www.jenitennison.com/xslt/xspec"
   type="t:test-my-xproc-step"
   version="3.1">

   <!-- What's different here compared to take2:
      You pass in the XSpec description document through an input port of this step itself -->

   <p:import href="my-xproc-step.xpl"/>
   <p:import href="../../../src/xproc3/harness-lib.xpl"/>

   <p:input port="source" href="test-my-xproc-step.xspec"/>
   <p:output port="result"/>
   <p:option name="xspec-home" select="resolve-uri('../../../')"/>

   <!-- compile the suite into a stylesheet -->
   <t:compile-xslt name="compile">
      <p:with-option name="xspec-home" select="$xspec-home"/>
   </t:compile-xslt>
   
   <!-- run it -->
   <p:xslt name="run" template-name="t:main">
      <p:with-input port="source">
         <p:empty/>
      </p:with-input>
      <p:with-input port="stylesheet" pipe="@compile"/>
   </p:xslt>
   
   <!-- format the report -->
   <t:format-report>
      <p:with-option name="xspec-home" select="$xspec-home"/>
   </t:format-report>

</p:declare-step>
