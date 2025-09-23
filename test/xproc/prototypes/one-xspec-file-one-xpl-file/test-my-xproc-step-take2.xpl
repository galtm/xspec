<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
   xmlns:ex="x-urn:example:xproc" xmlns:x="http://www.jenitennison.com/xslt/xspec"
   type="x:test-my-xproc-step"
   version="3.1">

    <!-- What's different here: You pass in the XSpec description document through
        an input port on x:compile-xslt -->
   <p:import href="my-xproc-step.xpl"/>
   <p:import href="../../../src/xproc3/harness-lib.xpl"/>
   <p:output port="result"/>
   <p:option name="xspec-home" select="resolve-uri('../../../')"/>

   <!-- Compile the .xspec file as usual -->
   <x:compile-xslt name="compile">
      <p:with-input href="test-my-xproc-step.xspec"/>
      <p:with-option name="xspec-home" select="$xspec-home"/>
   </x:compile-xslt> 
   <!-- Run the compiled stylesheet. Since we're in XProc, the XSLT knows about the
      function that corresponds to the XProc step being tested. -->
   <p:xslt template-name="x:main">
      <p:with-input port="source"><p:empty/></p:with-input>
      <p:with-input port="stylesheet" pipe="@compile"/>
   </p:xslt>
   <!-- Format the results as HTML, as usual. -->
   <x:format-report>
      <p:with-option name="xspec-home" select="$xspec-home"/>
   </x:format-report>

</p:declare-step>
