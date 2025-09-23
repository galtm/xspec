<?xml version="1.0" encoding="UTF-8"?>
<p:library xmlns:p="http://www.w3.org/ns/xproc"
   xmlns:ex="x-urn:example:xproc" version="3.1">

   <p:declare-step type="ex:process">
      <p:input port="source" content-types="xml html"/>
      <p:output port="result" content-types="xml html"/>
      <p:add-attribute attribute-name="do" attribute-value="something"/>
   </p:declare-step>
</p:library>
