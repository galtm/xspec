<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="3.0"
	xmlns:x="http://www.jenitennison.com/xslt/xspec" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable as="map(xs:string, item())" name="x:schematron-preprocessor" select="
			(
			map {
				'name': 'skeleton',
				'stylesheets': [
					resolve-uri('iso-schematron/iso_dsdl_include.xsl'),
					resolve-uri('iso-schematron/iso_abstract_expand.xsl'),
					resolve-uri('iso-schematron/iso_svrl_for_xslt2.xsl')
				]
			},
			map {
				'name': 'schxslt',
				'stylesheets': [
					resolve-uri('schxslt/2.0/include.xsl'),
					resolve-uri('schxslt/2.0/expand.xsl'),
					resolve-uri('schxslt/2.0/compile-for-svrl.xsl')
				]
			}
			)[doc-available(?stylesheets?1)]" static="yes" xml:base="../../lib/" />
</xsl:stylesheet>
