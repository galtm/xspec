<?xml version="1.0" encoding="UTF-8"?>
<p:library xmlns:p="http://www.w3.org/ns/xproc"
   xmlns:ex="x-urn:example:xproc" xmlns:tex="x-urn:example:xproc:test"
   xmlns:x="http://www.jenitennison.com/xslt/xspec"
   version="3.1">

   <p:declare-step type="ex:process">
      <p:input port="source" content-types="xml html"/>
      <p:output port="result" content-types="xml html"/>
      <p:add-attribute attribute-name="do" attribute-value="something"/>
   </p:declare-step>

   <!-- tex:process doesn't work. I can't get it to recognize the function. -->
   <p:declare-step type="tex:process" name="process-test">
      <p:import href="../../../src/xproc3/run-xslt.xpl"/>
      <p:import href="../../../src/xproc3/harness-lib.xpl"/>
      <p:input port="source" primary="true">
         <p:inline>
            <x:description xmlns:x="http://www.jenitennison.com/xslt/xspec"
               xmlns:ex="x-urn:example:xproc"
               stylesheet="../../../test/do-nothing.xsl">
               <x:scenario label="Calling an XProc step as a function">
                  <x:call function="ex:process">
                     <x:param>
                        <could/>
                     </x:param>
                  </x:call>
                  <x:expect label="could do something"
                     test="$x:result('result')" select="/">
                     <could do="something"/>
                  </x:expect>
               </x:scenario>
            </x:description>
         </p:inline>
      </p:input>
      <p:output port="result"/>
      <!-- Error, cannot find function
      <x:run-xslt>
         <p:with-input port="source" href="../one-xspec-file-one-xpl-file/test-my-xproc-step.xspec"/>
         <p:with-option name="xspec-home" select="resolve-uri('../../../')"/>
      </x:run-xslt>
      -->
      <p:variable name="xspec-home" select="resolve-uri('../../../')"/> 
      <!-- Compile the .xspec file as usual -->
      <x:compile-xslt name="compile">
         <p:with-input port="source" href="test-my-xproc-step.xspec"/>
         <p:with-option name="xspec-home" select="$xspec-home"/>
      </x:compile-xslt> 
      <!-- Run the compiled stylesheet. Since we're in XProc, the XSLT knows about the
      function that corresponds to the XProc step being tested. -->
      <p:xslt template-name="x:main">
         <p:with-input port="source"><p:empty/></p:with-input>
         <p:with-input port="stylesheet" pipe="@compile"/>
      </p:xslt>
<!--      <!-\- Format the results as HTML, as usual. -\->
      <x:format-report>
         <p:with-option name="xspec-home" select="$xspec-home"/>
      </x:format-report>
-->      
   </p:declare-step>

</p:library>
