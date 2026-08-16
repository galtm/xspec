#
# Simple test for using XQuery with BaseX (XQuery with BaseX)
#

@test "CLI with -processor basex (XQuery with BaseX)" {
    if [ -z "${BASEX_JAR}" ]; then
        skip "BASEX_JAR is not defined"
    fi

    myrun ../bin/xspec.sh -q -processor basex basex-soundex.xspec

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 3]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
    
    # HTML report file contains the (default) blackwhite CSS theme
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/basex-soundex-result.html" \
        -xsl:check-html-css.xsl STYLE-CONTAINS=test-report-colors-blackwhite.css
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
    
    # HTML report file contains CSS inline
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/basex-soundex-result.html" \
        -xsl:check-html-css.xsl
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
    
    * Default set of files
    myrun env LC_ALL=C ls "${test_dir}"
    [ "${#lines[@]}" = "3" ]
    [ "${lines[0]}" = "basex-soundex-compiled.xq" ]
    [ "${lines[1]}" = "basex-soundex-result.html" ]
    [ "${lines[2]}" = "basex-soundex-result.xml" ]
}

@test "Ant with xspec.xquery.processor basex (XQuery with BaseX)" {
    if [ -z "${BASEX_JAR}" ]; then
        skip "BASEX_JAR is not defined"
    fi

    myrun ant \
        -buildfile=../build.xml \
        -lib "${SAXON_ANT_LIB}" \
        -Dtest.type="q" \
        -Dxspec.xquery.processor="basex" \
        -Dxspec.basex.classpath="${BASEX_JAR}" \
        -Dxspec.xml="${PWD}/basex-soundex.xspec"

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 16]}" = "     [xslt] passed: 1 / pending: 0 / failed: 0 / total: 1" ]
    
    # HTML report file contains CSS inline
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/basex-soundex-result.html" \
        -xsl:check-html-css.xsl
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
    
    * Default set of files
    myrun env LC_ALL=C ls "${test_dir}"
    [ "${#lines[@]}" = "4" ]
    [ "${lines[0]}" = "basex-soundex_xml-to-properties.xml" ]
    [ "${lines[1]}" = "basex-soundex-compiled.xq" ]
    [ "${lines[2]}" = "basex-soundex-result.html" ]
    [ "${lines[3]}" = "basex-soundex-result.xml" ]
}

@test "XML Calabash with processor basex (XQuery with BaseX)" {
    if [ -z "${BASEX_JAR}" ]; then
        skip "BASEX_JAR is not defined"
    fi

    if [ -z "${XMLCALABASH3_DIR}" ]; then
        skip "XMLCALABASH3_DIR is not defined"
    fi

    if [ -z "${XMLCALABASH3_JAR}" ]; then
        skip "XMLCALABASH3_JAR is not defined"
    fi

    myrun java -cp "${XMLCALABASH3_JAR}:${XMLCALABASH3_DIR}/extra/*:${BASEX_JAR}" \
        com.xmlcalabash.app.Main \
        --input:source=basex-soundex.xspec \
        --output:result="file:${test_dir}/basex-soundex-result.html" \
        ../src/xproc3/run-xquery.xpl \
        xspec-home="file:${parent_dir_abs}/" \
        processor=basex 

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 1]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
    
    # HTML report file contains CSS inline
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/basex-soundex-result.html" \
        -xsl:check-html-css.xsl
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
}
#
# Simple test for using XQuery with Saxon (XQuery with Saxon)
#

@test "CLI with -processor saxon (XQuery with saxon)" {
    myrun ../bin/xspec.sh -q -processor saxon transform.xspec

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 3]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
    
    # HTML report file contains the (default) blackwhite CSS theme
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/transform-result.html" \
        -xsl:check-html-css.xsl STYLE-CONTAINS=test-report-colors-blackwhite.css
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
    
    # HTML report file contains CSS inline
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/transform-result.html" \
        -xsl:check-html-css.xsl
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
    
    * Default set of files
    myrun env LC_ALL=C ls "${test_dir}"
    [ "${#lines[@]}" = "3" ]
    [ "${lines[0]}" = "transform-compiled.xq" ]
    [ "${lines[1]}" = "transform-result.html" ]
    [ "${lines[2]}" = "transform-result.xml" ]
}

@test "Ant with xspec.xquery.processor saxon (XQuery with saxon)" {
    myrun ant \
        -buildfile=../build.xml \
        -lib "${SAXON_ANT_LIB}" \
        -Dtest.type="q" \
        -Dxspec.xquery.processor="saxon" \
        -Dxspec.xml="${PWD}/transform.xspec"

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 16]}" = "     [xslt] passed: 1 / pending: 0 / failed: 0 / total: 1" ]
    
    # HTML report file contains CSS inline
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/transform-result.html" \
        -xsl:check-html-css.xsl
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
    
    * Default set of files
    myrun env LC_ALL=C ls "${test_dir}"
    [ "${#lines[@]}" = "4" ]
    [ "${lines[0]}" = "transform_xml-to-properties.xml" ]
    [ "${lines[1]}" = "transform-compiled.xq" ]
    [ "${lines[2]}" = "transform-result.html" ]
    [ "${lines[3]}" = "transform-result.xml" ]
}

@test "XML Calabash with processor saxon (XQuery with Saxon)" {
    if [ -z "${XMLCALABASH3_JAR}" ]; then
        skip "XMLCALABASH3_JAR is not defined"
    fi

    myrun java -jar "${XMLCALABASH3_JAR}" \
        --input:source=transform.xspec \
        --output:result="file:${test_dir}/transform-result.html" \
        ../src/xproc3/run-xquery.xpl \
        xspec-home="file:${parent_dir_abs}/" \
        processor=saxon 

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 1]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
    
    # HTML report file contains CSS inline
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/transform-result.html" \
        -xsl:check-html-css.xsl
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
}
#
# Test using XQuery with mixed case BaseX (XQuery with BaseX)
#

@test "CLI with -processor BaseX (XQuery with BaseX)" {
    if [ -z "${BASEX_JAR}" ]; then
        skip "BASEX_JAR is not defined"
    fi

    myrun ../bin/xspec.sh -q -processor BaseX basex-soundex.xspec

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 3]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
}

@test "Ant with xspec.xquery.processor BaseX (XQuery with BaseX)" {
    if [ -z "${BASEX_JAR}" ]; then
        skip "BASEX_JAR is not defined"
    fi

    myrun ant \
        -buildfile=../build.xml \
        -lib "${SAXON_ANT_LIB}" \
        -Dtest.type="q" \
        -Dxspec.xquery.processor="BaseX" \
        -Dxspec.basex.classpath="${BASEX_JAR}" \
        -Dxspec.xml="${PWD}/basex-soundex.xspec"

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 16]}" = "     [xslt] passed: 1 / pending: 0 / failed: 0 / total: 1" ]
}

@test "XML Calabash with processor BaseX (XQuery with BaseX)" {
    if [ -z "${BASEX_JAR}" ]; then
        skip "BASEX_JAR is not defined"
    fi

    if [ -z "${XMLCALABASH3_DIR}" ]; then
        skip "XMLCALABASH3_DIR is not defined"
    fi

    if [ -z "${XMLCALABASH3_JAR}" ]; then
        skip "XMLCALABASH3_JAR is not defined"
    fi

    myrun java -cp "${XMLCALABASH3_JAR}:${XMLCALABASH3_DIR}/extra/*:${BASEX_JAR}" \
        com.xmlcalabash.app.Main \
        --input:source=basex-soundex.xspec \
        --output:result="file:${test_dir}/basex-soundex-result.html" \
        ../src/xproc3/run-xquery.xpl \
        xspec-home="file:${parent_dir_abs}/" \
        processor=BaseX 

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 1]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
}
#
# Test using XQuery with mixed case Saxon (XQuery with Saxon)
#

@test "CLI with -processor Saxon (XQuery with Saxon)" {
    if [ -z "${BASEX_JAR}" ]; then
        skip "BASEX_JAR is not defined"
    fi

    myrun ../bin/xspec.sh -q -processor Saxon transform.xspec

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 3]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
}

@test "Ant with xspec.xquery.processor Saxon (XQuery with Saxon)" {
    if [ -z "${BASEX_JAR}" ]; then
        skip "BASEX_JAR is not defined"
    fi

    myrun ant \
        -buildfile=../build.xml \
        -lib "${SAXON_ANT_LIB}" \
        -Dtest.type="q" \
        -Dxspec.xquery.processor="Saxon" \
        -Dxspec.basex.classpath="${BASEX_JAR}" \
        -Dxspec.xml="${PWD}/transform.xspec"

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 16]}" = "     [xslt] passed: 1 / pending: 0 / failed: 0 / total: 1" ]
}

@test "XML Calabash with processor Saxon (XQuery with Saxon)" {
    if [ -z "${XMLCALABASH3_JAR}" ]; then
        skip "XMLCALABASH3_JAR is not defined"
    fi

    myrun java -jar "${XMLCALABASH3_JAR}" \
        --input:source=transform.xspec \
        --output:result="file:${test_dir}/transform-result.html" \
        ../src/xproc3/run-xquery.xpl \
        xspec-home="file:${parent_dir_abs}/" \
        processor=Saxon 

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 1]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
}
#
# Test with XQuery processor not set (XQuery with Saxon)
#

@test "CLI with no processor value (XQuery with Saxon)" {
    myrun ../bin/xspec.sh -q transform.xspec

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 3]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
}

@test "Ant with no processor value (XQuery with Saxon)" {
    myrun ant \
        -buildfile=../build.xml \
        -lib "${SAXON_ANT_LIB}" \
        -Dtest.type="q" \
        -Dxspec.xml="${PWD}/transform.xspec"

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 16]}" = "     [xslt] passed: 1 / pending: 0 / failed: 0 / total: 1" ]
}

@test "XML Calabash with no processor value (XQuery with Saxon)" {
    if [ -z "${XMLCALABASH3_JAR}" ]; then
        skip "XMLCALABASH3_JAR is not defined"
    fi

    myrun java -jar "${XMLCALABASH3_JAR}" \
        --input:source=transform.xspec \
        --output:result="file:${test_dir}/transform-result.html" \
        ../src/xproc3/run-xquery.xpl \
        xspec-home="file:${parent_dir_abs}/" 

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 1]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
}
#
# BASEX_CUSTOM_OPTIONS / basex.custom.options (XQuery with BaseX)
#

@test "CLI with BASEX_CUSTOM_OPTIONS (XQuery with BaseX)" {
    if [ -z "${BASEX_JAR}" ]; then
        skip "BASEX_JAR is not defined"
    fi

    export BASEX_CUSTOM_OPTIONS="-bQ{x-urn:test:xspec-global-override}external-value_vs_global-variable=override -bQ{x-urn:test:xspec-global-override}empty-external-value_vs_global-variable= -bQ{x-urn:test:xspec-global-override}non-external-value_vs_global-variable=override"
    myrun ../bin/xspec.sh -q -processor basex global-override-query.xspec

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 3]}" = "passed: 3 / pending: 0 / failed: 0 / total: 3" ]
    
    # HTML report file contains the (default) blackwhite CSS theme
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/global-override-query-result.html" \
        -xsl:check-html-css.xsl STYLE-CONTAINS=test-report-colors-blackwhite.css
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
    
    # HTML report file contains CSS inline
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/global-override-query-result.html" \
        -xsl:check-html-css.xsl
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
    
    * Default set of files
    myrun env LC_ALL=C ls "${test_dir}"
    [ "${#lines[@]}" = "3" ]
    [ "${lines[0]}" = "global-override-query-compiled.xq" ]
    [ "${lines[1]}" = "global-override-query-result.html" ]
    [ "${lines[2]}" = "global-override-query-result.xml" ]
}

@test "Ant with basex.custom.options (XQuery with BaseX)" {
    if [ -z "${BASEX_JAR}" ]; then
        skip "BASEX_JAR is not defined"
    fi

    myrun ant \
        -buildfile=../build.xml \
        -lib "${SAXON_ANT_LIB}" \
        -Dtest.type="q" \
        -Dxspec.xquery.processor="basex" \
        -Dbasex.custom.options="-bQ{x-urn:test:xspec-global-override}external-value_vs_global-variable=override -bQ{x-urn:test:xspec-global-override}empty-external-value_vs_global-variable= -bQ{x-urn:test:xspec-global-override}non-external-value_vs_global-variable=override" \
        -Dxspec.basex.classpath="${BASEX_JAR}" \
        -Dxspec.xml="${PWD}/basex-soundex.xspec"

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 16]}" = "     [xslt] passed: 1 / pending: 0 / failed: 0 / total: 1" ]
    
    # HTML report file contains CSS inline
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/basex-soundex-result.html" \
        -xsl:check-html-css.xsl
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
    
    * Default set of files
    myrun env LC_ALL=C ls "${test_dir}"
    [ "${#lines[@]}" = "4" ]
    [ "${lines[0]}" = "basex-soundex_xml-to-properties.xml" ]
    [ "${lines[1]}" = "basex-soundex-compiled.xq" ]
    [ "${lines[2]}" = "basex-soundex-result.html" ]
    [ "${lines[3]}" = "basex-soundex-result.xml" ]
}
#
# CLI - XSLT with XQUERY_PROCESSOR set (shows value is ignored if test type not XQuery)
#

@test "CLI with XQUERY_PROCESSOR basex (Schematron with XSLT)" {
    export XQUERY_PROCESSOR="basex"
    myrun ../bin/xspec.sh -s ../tutorial/schematron/demo-01.xspec

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 3]}" = "passed: 3 / pending: 0 / failed: 0 / total: 3" ]
    
    # HTML report file contains the (default) blackwhite CSS theme
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/demo-01-result.html" \
        -xsl:check-html-css.xsl STYLE-CONTAINS=test-report-colors-blackwhite.css
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
    
    # HTML report file contains CSS inline
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/demo-01-result.html" \
        -xsl:check-html-css.xsl
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
}
#
# CLI - XQuery with BaseX using XQUERY_PROCESSOR
#

@test "CLI with XQUERY_PROCESSOR basex (XQuery with BaseX)" {
    if [ -z "${BASEX_JAR}" ]; then
        skip "BASEX_JAR is not defined"
    fi

    export XQUERY_PROCESSOR="basex"
    myrun ../bin/xspec.sh -q basex-soundex.xspec

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 3]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
    
    # HTML report file contains the (default) blackwhite CSS theme
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/basex-soundex-result.html" \
        -xsl:check-html-css.xsl STYLE-CONTAINS=test-report-colors-blackwhite.css
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
    
    # HTML report file contains CSS inline
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/basex-soundex-result.html" \
        -xsl:check-html-css.xsl
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
    
    * Default set of files
    myrun env LC_ALL=C ls "${test_dir}"
    [ "${#lines[@]}" = "3" ]
    [ "${lines[0]}" = "basex-soundex-compiled.xq" ]
    [ "${lines[1]}" = "basex-soundex-result.html" ]
    [ "${lines[2]}" = "basex-soundex-result.xml" ]
}

@test "CLI with XQUERY_PROCESSOR BaseX (XQuery with BaseX)" {
    if [ -z "${BASEX_JAR}" ]; then
        skip "BASEX_JAR is not defined"
    fi

    export XQUERY_PROCESSOR="BaseX"
    myrun ../bin/xspec.sh -q basex-soundex.xspec

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 3]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
    
    # HTML report file contains the (default) blackwhite CSS theme
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/basex-soundex-result.html" \
        -xsl:check-html-css.xsl STYLE-CONTAINS=test-report-colors-blackwhite.css
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
    
    # HTML report file contains CSS inline
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/basex-soundex-result.html" \
        -xsl:check-html-css.xsl
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
    
    * Default set of files
    myrun env LC_ALL=C ls "${test_dir}"
    [ "${#lines[@]}" = "3" ]
    [ "${lines[0]}" = "basex-soundex-compiled.xq" ]
    [ "${lines[1]}" = "basex-soundex-result.html" ]
    [ "${lines[2]}" = "basex-soundex-result.xml" ]
}
#
# CLI - XQuery with Saxon using XQUERY_PROCESSOR
#

@test "CLI with XQUERY_PROCESSOR saxon (XQuery with Saxon)" {
    export XQUERY_PROCESSOR="saxon"
    myrun ../bin/xspec.sh -q transform.xspec

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 3]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
    
    # HTML report file contains the (default) blackwhite CSS theme
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/transform-result.html" \
        -xsl:check-html-css.xsl STYLE-CONTAINS=test-report-colors-blackwhite.css
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
    
    # HTML report file contains CSS inline
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/transform-result.html" \
        -xsl:check-html-css.xsl
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
    
    * Default set of files
    myrun env LC_ALL=C ls "${test_dir}"
    [ "${#lines[@]}" = "3" ]
    [ "${lines[0]}" = "transform-compiled.xq" ]
    [ "${lines[1]}" = "transform-result.html" ]
    [ "${lines[2]}" = "transform-result.xml" ]
}

@test "CLI with XQUERY_PROCESSOR Saxon (XQuery with Saxon)" {
    export XQUERY_PROCESSOR="Saxon"
    myrun ../bin/xspec.sh -q transform.xspec

    [ "$status" -eq 0 ] 
    [ "${lines[${#lines[@]} - 3]}" = "passed: 1 / pending: 0 / failed: 0 / total: 1" ]
    
    # HTML report file contains the (default) blackwhite CSS theme
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/transform-result.html" \
        -xsl:check-html-css.xsl STYLE-CONTAINS=test-report-colors-blackwhite.css
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
    
    # HTML report file contains CSS inline
    myrun java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -s:"${test_dir}/transform-result.html" \
        -xsl:check-html-css.xsl
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "true" ]
    
    * Default set of files
    myrun env LC_ALL=C ls "${test_dir}"
    [ "${#lines[@]}" = "3" ]
    [ "${lines[0]}" = "transform-compiled.xq" ]
    [ "${lines[1]}" = "transform-result.html" ]
    [ "${lines[2]}" = "transform-result.xml" ]
}
#
# Error Tests - XQuery with invalid 'processor' value
#

@test "CLI with -processor bogus (XQuery)" {
    myrun ../bin/xspec.sh -q -processor bogus ../tutorial/xquery-tutorial.xspec

    [ "$status" -eq 1 ] 
    [ "${lines[0]}" = "-processor option for XQuery must be saxon or basex, value is bogus" ]
}

@test "Ant with xspec.xquery.processor bogus (XQuery)" {
    myrun ant \
        -buildfile=../build.xml \
        -lib "${SAXON_ANT_LIB}" \
        -Dtest.type="q" \
        -Dxspec.xquery.processor="bogus" \
        -Dxspec.xml="${PWD}/../tutorial/xquery-tutorial.xspec"

    [ "$status" -eq 1 ] 
    assert_regex "${lines[${#lines[@]} - 3]}" ".*Invalid xspec\.xquery\.processor: 'bogus'"
}

@test "XML Calabash with -processor bogus (XQuery)" {
    if [ -z "${XMLCALABASH3_JAR}" ]; then
        skip "XMLCALABASH3_JAR is not defined"
    fi

    myrun java -jar "${XMLCALABASH3_JAR}" \
        --input:source=../tutorial/xquery-tutorial.xspec \
        --output:result="file:${test_dir}/xquery-tutorial-result.html" \
        ../src/xproc3/run-xquery.xpl \
        xspec-home="file:${parent_dir_abs}/" \
        processor=bogus 

    [ "$status" -eq 1 ] 
    assert_regex "${lines[${#lines[@]} - 1]}" "ERROR t:ERR005.* processor option for XQuery must be saxon or basex, value is bogus"
}
#
# Error Tests - 'processor' not allowed for the test type (value of file name and processor are not used)
#

@test "CLI with -processor for default test type (XSLT)" {
    myrun ../bin/xspec.sh -processor bogus ../tutorial/escape-for-regex.xspec

    [ "$status" -eq 1 ] 
    [ "${lines[0]}" = "-processor option is not supported for this test type" ]
}

@test "Ant with xspec.xquery.processor for default test type (XSLT)" {
    myrun ant \
        -buildfile=../build.xml \
        -lib "${SAXON_ANT_LIB}" \
        -Dxspec.xquery.processor="saxon" \
        -Dxspec.xml="${PWD}/../tutorial/escape-for-regex.xspec"

    [ "$status" -eq 1 ] 
    assert_regex "${lines[${#lines[@]} - 3]}" ".*xspec\.xquery\.processor is supported only with test\.type of 'q'"
}

@test "CLI with -processor for wrong test type (XSLT)" {
    myrun ../bin/xspec.sh -t -processor bogus ../tutorial/escape-for-regex.xspec

    [ "$status" -eq 1 ] 
    [ "${lines[0]}" = "-processor option is not supported for this test type" ]
}

@test "Ant with xspec.xquery.processor for wrong test type (XSLT)" {
    myrun ant \
        -buildfile=../build.xml \
        -lib "${SAXON_ANT_LIB}" \
        -Dtest.type="t" \
        -Dxspec.xquery.processor="saxon" \
        -Dxspec.xml="${PWD}/../tutorial/escape-for-regex.xspec"

    [ "$status" -eq 1 ] 
    assert_regex "${lines[${#lines[@]} - 3]}" ".*xspec\.xquery\.processor is supported only with test\.type of 'q'"
}

@test "CLI with -processor for wrong test type (Schematron)" {
    myrun ../bin/xspec.sh -s -processor bogus ../tutorial/schematron/demo-03.xspec

    [ "$status" -eq 1 ] 
    [ "${lines[0]}" = "-processor option is not supported for this test type" ]
}

@test "Ant with xspec.xquery.processor for wrong test type (Schematron)" {
    myrun ant \
        -buildfile=../build.xml \
        -lib "${SAXON_ANT_LIB}" \
        -Dtest.type="s" \
        -Dxspec.xquery.processor="saxon" \
        -Dxspec.xml="${PWD}/../tutorial/schematron/demo-03.xspec"

    [ "$status" -eq 1 ] 
    assert_regex "${lines[${#lines[@]} - 3]}" ".*xspec\.xquery\.processor is supported only with test\.type of 'q'"
}

@test "CLI with -processor for wrong test type (XProc)" {
    export SAXON_CP="${XMLCALABASH3_JAR}"
    myrun ../bin/xspec.sh -p -processor bogus ../tutorial/xproc/xproc-testing-demo.xspec

    [ "$status" -eq 1 ] 
    [ "${lines[0]}" = "-processor option is not supported for this test type" ]
}

@test "Ant with xspec.xquery.processor for wrong test type (XProc)" {
    myrun ant \
        -buildfile=../build.xml \
        -lib "${SAXON_ANT_LIB}" \
        -Dtest.type="p" \
        -Dxspec.xquery.processor="saxon" \
        -Dxspec.xmlcalabash.classpath="${XMLCALABASH3_JAR}" \
        -Dxspec.xml="${PWD}/../tutorial/xproc/xproc-testing-demo.xspec"

    [ "$status" -eq 1 ] 
    assert_regex "${lines[${#lines[@]} - 3]}" ".*xspec\.xquery\.processor is supported only with test\.type of 'q'"
}
