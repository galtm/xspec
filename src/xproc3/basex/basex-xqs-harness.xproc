<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
            xmlns:c="http://www.w3.org/ns/xproc-step"
            xmlns:x="http://www.jenitennison.com/xslt/xspec"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:map="http://www.w3.org/2005/xpath-functions/map"
            name="basex-xqs-harness"
            type="x:basex-xqs-harness"
            exclude-inline-prefixes="map xs x c p"
            version="3.1">

   <p:documentation>
      <p>This pipeline executes an XSpec test suite for Schematron with BaseX using the XQS implementation of Schematron.</p>
      <p><b>Primary input:</b> An XSpec test suite document.</p>
      <p><b>Primary output:</b> A formatted HTML XSpec report.</p>
      <p>'xspec-home' option: The directory where you unzipped the XSpec archive on your filesystem.</p>
      <p>'basex-cp' option: Classpath for BaseX, typically the location of BaseX .jar file.</p>
      <p>'xqs-location' option: Directory of XQS archive on your filesystem. Default: lib/XQS/ under xspec-home.</p>
   </p:documentation>

   <p:import href="schematron-preprocessor-xqs.xproc"/>
   <p:import href="basex-standalone-xquery-harness.xproc"/>

   <p:input port="source" primary="true" sequence="false" content-types="application/xml"/>
   <p:output port="result"
      serialization="map{
         'indent':true(),
         'method':'xhtml',
         'encoding':'UTF-8',
         'include-content-type':true(),
         'omit-xml-declaration':false()
      }"
      primary="true"/>

   <p:option name="parameters" as="map(xs:QName,item()*)?"/>

   <!-- preprocess; uses xspec-home and xqs-location options -->
   <x:schematron-preprocessor-xqs>
      <p:with-option name="parameters" select="$parameters"/>
   </x:schematron-preprocessor-xqs>

   <!-- run generated test and produce report; uses xspec-home and basex-cp options -->
   <x:basex-standalone-xquery-harness>
      <p:with-option name="parameters" select="$parameters"/>
   </x:basex-standalone-xquery-harness>

</p:declare-step>
