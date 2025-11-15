# Proposal: Using XSpec to test XProc Steps

## Status

This document is an exploratory proposal, meant to guide design and development of an extension of XSpec capabilities for testing XProc steps. An implementation is in progress but not yet released or even on the `master` branch.

## Requirements

What new capabilities must XSpec have to enable testing of an XProc step?

The test author must be able to:

1. Identify the XProc file that (directly or through imports) declares the step to test. The file can have outermost element `p:library` or `p:declare-step`.
1. Indicate a step to call.
1. Provide zero or more documents at each of the step's input ports.
1. Provide values for zero or more options.
1. Verify zero or more documents at each of one or more output ports.
1. Indicate which output port a verification pertains to.
1. Verify that a step completed without raising an error, even if the step has no output ports.
1. Specify configuration of the XProc processor. The configuration applies to the entire test suite.

The XSpec processing must be able to:

1. Call the specified step with the specified inputs and option values.
1. Execute the test author's verifications.
1. Indicate the XProc file in the test result report. The test report should otherwise be the same as in the XSLT testing case.

### Non-essential but nice to have

1. If a particular output port has been specified in `<x:expect>` and there is exactly one document at that port, then make that document the context item for the XPath expression in `x:expect/@test`.
1. Remove limitation 7 below.

### Expected limitations

1. Requires XML Calabash 3 as the XProc processor, due to the implementation's dependency on an XML Calabash feature.
2. Requires the Saxon version that is bundled in XML Calabash 3, as the XSLT processor.
3. Can't test a step that has `visibility="private"`.
4. Can't test a step that doesn't have `@type`.
5. Can't test a local substep declared within a step.
6. Can't test a standard step, only custom ones.
7. Whether or not a step's input port declares default document(s), the XSpec scenario for that step must provide `<x:input>` for the port. That is, you can't omit `<x:input>` and pick up the default.
8. If a step has `use-when` on any child `<p:input>` element, XSpec doesn't know whether that input port is actually part of the step. Not sure if this limitation can be removed; for now, XSpec displays a warning and proceeds as if the `use-when` expression is true.
9. Can't specify configuration of the XProc processor on a per-scenario basis.

## Vocabulary and Markup Design

Proposed markup changes:

1. For identifying the XProc file, add `xproc` attribute to existing `<x:description>` element.
1. For calling a step, use existing `<x:call>` element and add new `step` attribute.
1. For providing documents at a step input port, introduce new `<x:input>` element with a `port` attribute. The way you specify documents for `<x:input>` is analogous to specifying a function argument in `<x:param>`.
1. For providing a step option, introduce new `<x:option>` element with a `name` attribute. The way you specify a value for `<x:option>` is analogous to specifying a function argument in `<x:param>`.
1. For extending the test runner with functions that represent custom XProc steps (see "pipelineception" under "Implementation" below), add `xproc` attribute to existing `<x:helper>` element. The test runner is an XSLT transformation, and access to XProc behaviors is useful for working with non-XML documents, for instance.
1. For verifying results, `<x:expect>` works the same as in a test for XSLT or XQuery, with the following exception. For optionally focusing a given `<x:expect>` element on a particular output port, add `port` attribute (thanks for the idea, Sheila Thomson!). Consequences:
   1. Within that `<x:expect>` element only, XSpec defines `$x:result` as the document(s) at the specified output port.
   1. The `x:expect/@result-type` attribute pertains to this port-specific output.
   1. For an element `x:expect[@port][not(@test)][node()]`, the embedded nodes are automatically wrapped in a document node, even without specifying `select="/"`. This is different from the XSpec behavior for testing XSLT and XQuery, which could be potentially confusing. The motivation for this inconsistency is that nodes returned from XProc are always rooted at a document node, and all the extra `select="/"` attributes are clutter.
   1. If `x:expect[@port][not(@test)]` fails, the left side of a diff in the HTML test report shows the port-specific output.

_Outside_ an `<x:expect>` element having a `port` attribute, if `$x:result` is defined, then its value is a map with an entry for each output port of the step. In each map entry, the key is the output port name and the value is the document(s) at that output port.

## Files, and How to Run the Test Suite

1. In the proposed API, an XSpec test suite for XProc is a separate file.
1. A new XProc 3 step named `x:run-xproc` runs a test suite for XProc. The `xspec` input port accepts one XSpec test suite document. The `result` output port produces the corresponding HTML test result report.
1. The existing Windows and Linux/macOS command scripts add support for a `-p` flag to indicate that it is a test for XProc. As a prerequisite, the user must set the `SAXON_CP` environment variable to the path of the XML Calabash 3 jar file and any other jar files that are needed to execute the step. Currently, XML Calabash configuration options all have default values. (TODO: Add support for passing in the path to an XML Calabash configuration file.)
1. The existing Ant build script adds support for a `test.type` value of `p` to indicate that it is a test for XProc. As a prerequisite, the user must also set the `xspec.xmlcalabash.classpath` Ant property to the path of the XML Calabash 3 jar file and any other jar files that are needed to execute the step. Currently, XML Calabash configuration options all have default values. (TODO: Add support for passing in the path to an XML Calabash configuration file.)
1. The existing "Run XSpec Test" transformation scenario for Oxygen adds support for running tests for XProc. The prerequisite about `xspec.xmlcalabash.classpath` (preceding item) applies.

So far in my in-progress work, the `x:run-xproc` step runs faster than the command script or Ant script, at least on Windows.

Sample syntaxes from root of XSpec repository, assuming `XMLCALABASH3_JAR` is set to the path to `xmlcalabash-app-3.0.27.jar` (or latest available version):

```
java -jar %XMLCALABASH3_JAR% --input:source=tutorial/xproc/xproc-testing-demo.xspec --output:result=tutorial/xproc/xproc-testing-demo-xprocresult.html src/xproc3/xproc-testing/run-xproc.xpl
```

```
set SAXON_CP=%XMLCALABASH3_JAR%
bin\xspec.bat -p tutorial\xproc\xproc-testing-demo.xspec
```

The demo XSpec file in the syntaxes above has a deliberate failure. Look at the generated HTML report to see how the failure appears there.

I _think_ Saxon-PE and Saxon-EE users can follow the advice in [Upgrading Saxon](https://docs.xmlcalabash.com/userguide/current/running.html#upgrading-saxon) when running XSpec tests for XProc, but I haven't tried it.

## Implementation dependency

My implementation depends on the "pipelineception" feature (thanks, Norm Tovey-Walsh!) of XML Calabash 3 that provides access to a custom, typed XProc step via an XPath function by the same name. I have modified the XSpec compiler and formatter to build on the capabilities of XSpec for testing stylesheet functions.

## Questions

1. Are the limitations acceptable, including the dependency on the nonstandard pipelineception feature of XML Calabash?
1. Is the ability to omit `select="/"' on `<x:expect>` elements that meet certain criteria useful for conciseness or is it confusing/mysterious?
1. Does an XSpec test suite need the ability to provide a value for a static XProc option in a library? I'm not sure if it's possible, but I can explore if needed.
1. Are there considerations that need attention that I might not have thought of?
1. What should/can XSpec offer for testing steps that have side effects? For instance, your step writes a file to disk, and you want to delete a stale file before or after running the test suite. The existing XSpec test runner doesn't support setup/cleanup operations that occur before/after running test scenarios. You can potentially use an outside-XSpec driver that performs setup, then calls XSpec to run test scenarios, and then performs cleanup. Is that good enough? (Are side effects more prevalent with XProc than XSLT or XQuery? If not, this is a pre-existing problem that might not need to block the initial support for testing XProc.)
