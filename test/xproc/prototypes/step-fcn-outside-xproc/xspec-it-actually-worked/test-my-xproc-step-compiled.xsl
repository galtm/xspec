<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">
   <!-- the tested stylesheet -->
   <xsl:import href="file:/C:/MyStuff/github/xspec-mywork/test/do-nothing.xsl"/>
   <!-- XSpec library modules providing tools -->
   <xsl:include href="file:/C:/MyStuff/github/xspec-mywork/src/common/runtime-utils.xsl"/>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}stylesheet-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/C:/MyStuff/github/xspec-mywork/test/do-nothing.xsl</xsl:variable>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}xspec-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/C:/MyStuff/github/xspec-mywork/tutorial/xproc/step-fcn-outside-xproc/test-my-xproc-step.xspec</xsl:variable>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}is-external"
                 as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                 select="false()"/>
   <xsl:variable name="Q{urn:x-xspec:compile:impl}thread-aware"
                 as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                 select="(system-property('Q{http://www.w3.org/1999/XSL/Transform}product-name') eq 'SAXON') and starts-with(system-property('Q{http://www.w3.org/1999/XSL/Transform}product-version'), 'EE ')"
                 static="yes"/>
   <xsl:variable name="Q{urn:x-xspec:compile:impl}logical-processor-count"
                 as="Q{http://www.w3.org/2001/XMLSchema}integer"
                 use-when="$Q{urn:x-xspec:compile:impl}thread-aware"
                 select="Q{java:java.lang.Runtime}getRuntime() =&gt; Q{java:java.lang.Runtime}availableProcessors()"/>
   <xsl:variable name="Q{urn:x-xspec:compile:impl}thread-count"
                 as="Q{http://www.w3.org/2001/XMLSchema}integer"
                 select="1"
                 use-when="$Q{urn:x-xspec:compile:impl}thread-aware =&gt; not()"/>
   <!-- the main template to run the suite -->
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}main"
                 as="empty-sequence()">
      <xsl:context-item use="absent"/>
      <!-- info message -->
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('Q{http://www.w3.org/1999/XSL/Transform}product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('Q{http://www.w3.org/1999/XSL/Transform}product-version')"/>
      </xsl:message>
      <!-- set up the result document (the report) -->
      <xsl:result-document format="Q{{http://www.jenitennison.com/xslt/xspec}}xml-report-serialization-parameters">
         <xsl:element name="report" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:attribute name="xspec" namespace="">file:/C:/MyStuff/github/xspec-mywork/tutorial/xproc/step-fcn-outside-xproc/test-my-xproc-step.xspec</xsl:attribute>
            <xsl:attribute name="stylesheet" namespace="">file:/C:/MyStuff/github/xspec-mywork/test/do-nothing.xsl</xsl:attribute>
            <xsl:attribute name="date" namespace="" select="current-dateTime()"/>
            <!-- invoke each compiled top-level x:scenario -->
            <xsl:for-each select="1 to 1">
               <xsl:choose>
                  <xsl:when test=". eq 1">
                     <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:message terminate="yes">ERROR: Unhandled scenario invocation</xsl:message>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:for-each>
         </xsl:element>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Calling an XProc step as a function</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/C:/MyStuff/github/xspec-mywork/tutorial/xproc/step-fcn-outside-xproc/test-my-xproc-step.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Calling an XProc step as a function</xsl:text>
         </xsl:element>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:call" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:namespace name="ex">x-urn:example:xproc</xsl:namespace>
               <xsl:attribute name="function" namespace="">ex:process</xsl:attribute>
               <xsl:element name="x:param" namespace="http://www.jenitennison.com/xslt/xspec">
                  <xsl:namespace name="ex">x-urn:example:xproc</xsl:namespace>
                  <xsl:element name="could" namespace="">
                     <xsl:namespace name="ex">x-urn:example:xproc</xsl:namespace>
                     <xsl:namespace name="x">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}param-d58e1-doc" as="document-node()">
               <xsl:document>
                  <xsl:element name="could" namespace="">
                     <xsl:namespace name="ex">x-urn:example:xproc</xsl:namespace>
                     <xsl:namespace name="x">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                  </xsl:element>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="Q{urn:x-xspec:compile:impl}param-d58e1"
                          select="$Q{urn:x-xspec:compile:impl}param-d58e1-doc ! ( node() )"/>
            <xsl:sequence xmlns:ex="x-urn:example:xproc"
                          xmlns:x="http://www.jenitennison.com/xslt/xspec"
                          select="Q{x-urn:example:xproc}process($Q{urn:x-xspec:compile:impl}param-d58e1)"/>
         </xsl:variable>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="report-name" select="'result'"/>
         </xsl:call-template>
         <!-- invoke each compiled x:expect -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:message>could do something</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d54e6-doc" as="document-node()">
         <xsl:document>
            <xsl:element name="could" namespace="">
               <xsl:namespace name="ex">x-urn:example:xproc</xsl:namespace>
               <xsl:namespace name="x">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
               <xsl:attribute xmlns:ex="x-urn:example:xproc"
                              xmlns:x="http://www.jenitennison.com/xslt/xspec"
                              name="do"
                              namespace=""
                              select="'', ''"
                              separator="something"/>
            </xsl:element>
         </xsl:document>
      </xsl:variable>
      <xsl:variable xmlns:ex="x-urn:example:xproc"
                    xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d54e6"
                    select="$Q{urn:x-xspec:compile:impl}expect-d54e6-doc ! ( / )"><!--expected result--></xsl:variable>
      <!-- flag if @result-type is present but $x:result is not the right type -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}result-type-mismatch"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="false()"/>
      <!-- wrap $x:result into a document node if possible -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-items" as="item()*">
         <xsl:choose>
            <xsl:when test="exists($Q{http://www.jenitennison.com/xslt/xspec}result) and Q{urn:x-xspec:common:wrap}wrappable-sequence($Q{http://www.jenitennison.com/xslt/xspec}result)">
               <xsl:sequence select="Q{urn:x-xspec:common:wrap}wrap-nodes($Q{http://www.jenitennison.com/xslt/xspec}result)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- evaluate the predicate with $x:result (or its wrapper document node) as context item if it is a single item; if not, evaluate the predicate without context item -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-result" as="item()*">
         <xsl:choose>
            <xsl:when test="$Q{urn:x-xspec:compile:impl}result-type-mismatch"><!--In case of data type mismatch, do not process @test--></xsl:when>
            <xsl:when test="count($Q{urn:x-xspec:compile:impl}test-items) eq 1">
               <xsl:for-each select="$Q{urn:x-xspec:compile:impl}test-items">
                  <xsl:sequence xmlns:ex="x-urn:example:xproc"
                                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                                select="$x:result('result')"
                                version="3"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence xmlns:ex="x-urn:example:xproc"
                             xmlns:x="http://www.jenitennison.com/xslt/xspec"
                             select="$x:result('result')"
                             version="3"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}boolean-test"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="$Q{urn:x-xspec:compile:impl}test-result instance of Q{http://www.w3.org/2001/XMLSchema}boolean"/>
      <!-- did the test pass? -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean">
         <xsl:choose>
            <xsl:when test="$Q{urn:x-xspec:compile:impl}result-type-mismatch">
               <xsl:sequence select="false()"/>
            </xsl:when>
            <xsl:when test="$Q{urn:x-xspec:compile:impl}boolean-test">
               <xsl:message terminate="yes">ERROR in x:expect ('Calling an XProc step as a function could do something'): Boolean @test must not be accompanied by @as, @href, @select, or child node.</xsl:message>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d54e6, $Q{urn:x-xspec:compile:impl}test-result, '')"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>could do something</xsl:text>
         </xsl:element>
         <xsl:choose>
            <xsl:when test="$Q{urn:x-xspec:compile:impl}result-type-mismatch">
               <xsl:element name="expect-test-wrap" namespace="">
                  <xsl:element name="x:expect" namespace="http://www.jenitennison.com/xslt/xspec">
                     <xsl:namespace name="ex">x-urn:example:xproc</xsl:namespace>
                     <xsl:attribute name="result-type" namespace="">$x:result instance of </xsl:attribute>
                  </xsl:element>
               </xsl:element>
            </xsl:when>
            <xsl:when test="$Q{urn:x-xspec:compile:impl}boolean-test">
               <xsl:element name="expect-test-wrap" namespace="">
                  <xsl:element name="x:expect" namespace="http://www.jenitennison.com/xslt/xspec">
                     <xsl:namespace name="ex">x-urn:example:xproc</xsl:namespace>
                     <xsl:attribute name="test" namespace="">$x:result('result')</xsl:attribute>
                  </xsl:element>
               </xsl:element>
            </xsl:when>
            <xsl:when test="not($Q{urn:x-xspec:compile:impl}boolean-test)">
               <xsl:element name="expect-test-wrap" namespace="">
                  <xsl:element name="x:expect" namespace="http://www.jenitennison.com/xslt/xspec">
                     <xsl:namespace name="ex">x-urn:example:xproc</xsl:namespace>
                     <xsl:attribute name="test" namespace="">$x:result('result')</xsl:attribute>
                  </xsl:element>
               </xsl:element>
               <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
                  <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}test-result"/>
                  <xsl:with-param name="report-name" select="'result'"/>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise/>
         </xsl:choose>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d54e6"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
