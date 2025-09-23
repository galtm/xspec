<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
   xmlns:ex="x-urn:example:xproc" xmlns:t="http://www.jenitennison.com/xslt/xspec"
   type="t:test-my-xproc-step"
   version="3.1">

   <!-- What's different here compared to take4: use of t:run-xslt instead of
      copying its 3 substeps. -->

   <!-- QUESTION: Could this .xpl file have been generated from an XSpec file
      that specifies xproc="my-xproc-step.xpl" and provides the scenarios?
      Probably, but then are you running two commands, one to generate this
      XProc file and the next to actually run it in XML Calabash? Who's
      orchestrating the process? A command script that calls XML Calabash twice,
      or Saxon to generate the .xpl code and XML Calabash to execute it?

      Can it be done with one Saxon XSLT command if we use the right configuration
      to make THIS step accessible as a step-based XPath function? Maybe it still
      has to be two Saxon calls because this step doesn't exist at initialization
      time. And if it's two calls, maybe there's no point in using Saxon instead
      of XML Calabash if your test target is an XProc step.
   
   -->

   <p:import href="my-xproc-step.xpl"/>
   <p:import href="../../../src/xproc3/run-xslt.xpl"/>
   <!-- DEBUG: I forgot why I introduced this static option. It doesn't seem to be used. -->
   <p:option name="test-target-location" static="true" select="'my-xproc-step.xpl'"/>

   <p:input port="source">
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
   </p:input>
   <p:output port="result"/>
   <p:option name="xspec-home" select="resolve-uri('../../../')"/>

   <t:run-xslt>
      <p:with-option name="xspec-home" select="$xspec-home"/>
   </t:run-xslt>

</p:declare-step>
