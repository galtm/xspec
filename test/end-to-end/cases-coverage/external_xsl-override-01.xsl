<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:csv="http://example.com/csv"
    exclude-result-prefixes="xs csv"
    version="3.0">
    <!--
        xsl:override Coverage Test Case
        Package is https://www.w3.org/TR/xslt-30/#packages-csv-library-example
        Modifications: Extra comments added; xsl:output element removed because extraneous.
    -->
    <xsl:use-package name="http://example.com/csv-parser"
                     package-version="*">                                      <!-- Expected ignored -->
        <xsl:override>                                                         <!-- Expected ignored -->
            <!-- Change the root element from 'csv' to 'root' -->
            <xsl:template match="csv" mode="csv:post-process">
                <root>
                    <xsl:apply-templates mode="csv:post-process"/>
                </root>
            </xsl:template>

            <!-- add an extra attribute that uses the context item -->
            <xsl:attribute-set name="csv:field-attributes"
                               use-attribute-sets="xsl:original">              <!-- Expected ignored -->
                <xsl:attribute name="type"
                               select="if (. castable as xs:decimal)
                                       then 'numeric'
                                       else 'string'"/>                        <!-- Expected ignored -->
            </xsl:attribute-set>

            <!-- use semicolon not comma between fields -->
            <xsl:variable name="csv:field-separator"
                          as="xs:string" select="';'"
                          visibility="public"/>

            <!-- prevent empty rows from appearing with empty lines -->
            <xsl:function name="csv:preprocess-line"
                          as="xs:string?"
                          visibility="public">
                <xsl:param name="line" as="xs:string"/>
                <xsl:variable name="norm-line"
                              select="normalize-space(xsl:original($line))"/>
                <xsl:sequence select="if (string-length($norm-line) > 0)
                                      then $norm-line
                                      else ()"/>
            </xsl:function>
        </xsl:override>
    </xsl:use-package>

    <!-- example input "file"  -->
    <xsl:variable name="input" as="xs:string">
        name;id;postal code
        "Braaksma Abel";34291;1210 KA
        "Berglund Anders";473892;9843 ZD
    </xsl:variable>

    <!-- entry point -->
    <xsl:template name="xsl:initial-template">
        <xsl:copy-of select="csv:parse($input)"/>
    </xsl:template>

    <!--
        LICENSE NOTICE
        
        This file is derived from "XSL Transformations (XSLT) Version 3.0", W3C Recommendation 8 June 2017.
        https://www.w3.org/TR/xslt-30/#packages-csv-library-example
        
        That document is licensed under the W3C Document License - 2023 version.
        Copyright © 2017 World Wide Web Consortium <https://www.w3.org/> . <https://www.w3.org/copyright/document-license-2023/>

        The code examples in the document are licensed under the W3C Software License. Copyright notice:
        Copyright © 2023 W3C®. This software or document includes material copied from or derived from XSL Transformations (XSLT) Version 3.0 (https://www.w3.org/TR/xslt-30).
        
        Text of W3C Document license: ../../../third-party-licenses/W3C-document-license-2023.txt
        Text of W3C Software license: ../../../third-party-licenses/W3C-software-license-2023.txt
    -->

</xsl:stylesheet>