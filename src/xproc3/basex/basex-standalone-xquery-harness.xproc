<?xml version="1.0" encoding="UTF-8"?>
<!-- ===================================================================== -->
<!--  File:       basex-standalone-xquery-harness.xproc                    -->
<!--  Author:     Florent Georges                                          -->
<!--  Date:       2011-08-30                                               -->
<!--  Later modifications: Updated to use XProc 3                          -->
<!--  URI:        http://github.com/xspec/xspec                            -->
<!--  Tags:                                                                -->
<!--    Copyright (c) 2011 Florent Georges (see end of file.)              -->
<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
            xmlns:c="http://www.w3.org/ns/xproc-step"
            xmlns:x="http://www.jenitennison.com/xslt/xspec"
            xmlns:pkg="http://expath.org/ns/pkg"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:map="http://www.w3.org/2005/xpath-functions/map"
            pkg:import-uri="http://www.jenitennison.com/xslt/xspec/basex/harness/standalone/xquery.xproc"
            name="basex-standalone-xquery-harness"
            type="x:basex-standalone-xquery-harness"
            exclude-inline-prefixes="map xs pkg x c p"
            version="3.1">

   <p:documentation>
      <p>This pipeline executes an XSpec test suite for XQuery with BaseX.</p>
      <p><b>Primary input:</b> An XSpec test suite document.</p>
      <p><b>Primary output:</b> A formatted HTML XSpec report.</p>
      <p>'xspec-home' option: The directory where you unzipped the XSpec archive on your filesystem.</p>
      <p>'basex-cp' option: Classpath for BaseX, typically the location of BaseX .jar file.</p>
   </p:documentation>

   <p:import href="../harness-lib.xpl"/>

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

   <p:if test="empty(/x:description/@query)">
      <p:error code="x:ERR003">
         <p:with-input port="source">
            <p:inline>
               <message>Source document must be an XSpec test suite with @query attribute</message>
            </p:inline>
         </p:with-input>
      </p:error>
   </p:if>

   <!-- compile the suite into a query -->
   <x:compile-xquery name="compile">
      <p:with-option name="parameters" select="$parameters"/>
   </x:compile-xquery>

   <x:escape-markup/>
   <p:text-replace pattern="^&lt;query(.*)>" replacement=""/>
   <p:text-replace pattern="&lt;/query>\s?$" replacement="" name="queryText"/>

   <!-- store it on disk in order to pass it to BaseX -->
   <!-- (Passing the query text in the OS command might exceed character limit?) -->
   <p:file-create-tempfile name="compiled-file-name"/>
   <p:variable name="compiled-file-href" pipe="@compiled-file-name" select="string(.)"/>
   <p:store name="store" href="{$compiled-file-href}" serialization="map{'method':'text'}">
      <p:with-input pipe="@queryText"/>
   </p:store>

   <!-- run it on basex -->
   <p:variable name="basex-flags" select="concat('-Q',$compiled-file-href)"/>
   <p:variable name="basex-cp" select="map:get($parameters, xs:QName('basex-cp'))"/>
   <p:os-exec command="java" name="exec" depends="store">
      <p:with-option name="args"
         select="('-cp', $basex-cp, 'org.basex.BaseX', $basex-flags)"/>
      <p:with-input port="source">
         <p:empty/>
      </p:with-input>
   </p:os-exec>

   <!-- cast result to XML or else x:format-report doesn't recognize /x:report -->
   <p:try>
      <p:cast-content-type content-type="application/xml">
         <p:with-input pipe="result@exec"/>
      </p:cast-content-type>
      <p:catch name="catch-all">
         <p:error code="x:ERR-OS">
            <p:with-input pipe="error@exec"/>
         </p:error>
      </p:catch>
   </p:try>

   <!-- log the report? -->
   <x:log if-set="log-xml-report">
      <p:with-option name="parameters" select="$parameters"/>         
   </x:log>

   <!-- format the report -->
   <x:format-report>
      <p:with-option name="parameters" select="$parameters"/>
   </x:format-report>

</p:declare-step>


<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
<!-- DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS COMMENT.             -->
<!--                                                                       -->
<!-- Copyright (c) 2011 Florent Georges                                    -->
<!--                                                                       -->
<!-- The contents of this file are subject to the MIT License (see the URI -->
<!-- http://www.opensource.org/licenses/mit-license.php for details).      -->
<!--                                                                       -->
<!-- Permission is hereby granted, free of charge, to any person obtaining -->
<!-- a copy of this software and associated documentation files (the       -->
<!-- "Software"), to deal in the Software without restriction, including   -->
<!-- without limitation the rights to use, copy, modify, merge, publish,   -->
<!-- distribute, sublicense, and/or sell copies of the Software, and to    -->
<!-- permit persons to whom the Software is furnished to do so, subject to -->
<!-- the following conditions:                                             -->
<!--                                                                       -->
<!-- The above copyright notice and this permission notice shall be        -->
<!-- included in all copies or substantial portions of the Software.       -->
<!--                                                                       -->
<!-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,       -->
<!-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF    -->
<!-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.-->
<!-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY  -->
<!-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,  -->
<!-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE     -->
<!-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                -->
<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
