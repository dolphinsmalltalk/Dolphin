﻿"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch
	subclass: #'MSXML.IXSLTemplate'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

MSXML.IXSLTemplate guid: (OS.COM.IID fromString: '{2933bf93-7b36-11d2-b20e-00c04f983e60}')!

MSXML.IXSLTemplate isEgressOnly: true!

MSXML.IXSLTemplate comment: '<IXSLTemplate> is a wrapper class for the COM interface ''MSXML2.IXSLTemplate'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IXSLTemplate Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(2933BF93-7B36-11D2-B20E-00C04F983E60), 
	helpstring("IXSLTemplate Interface"), 
	dual, 
	nonextensible
]
interface IXSLTemplate : IDispatch
 {
	[id(0x00000002), propputref, helpstring("stylesheet to use with processors")]
	HRESULT __stdcall stylesheet(
		[in]IXMLDOMNode* stylesheet);
	[id(0x00000002), propget, helpstring("stylesheet to use with processors")]
	HRESULT __stdcall stylesheet(
		[out, retval]IXMLDOMNode** stylesheet);
	[id(0x00000003), helpstring("create a new processor object")]
	HRESULT __stdcall createProcessor(
		[out, retval]IXSLProcessor** ppProcessor);
};
'!

!MSXML.IXSLTemplate categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !

!MSXML.IXSLTemplate methodsFor!

createProcessor
	"Answer the <IXSLProcessor> result of invoking the createProcessor() method of the COM object.
	Helpstring: create a new processor object"

	| answer |
	answer := IXSLProcessor newPointer.
	self CreateProcessor: answer.
	^answer asObject!

CreateProcessor: ppProcessor
	"Private - Invoke the createProcessor() method of the COM object.
	Helpstring: create a new processor object

		HRESULT __stdcall createProcessor(
			[out, retval]IXSLProcessor** ppProcessor);"

	<virtual stdcall: hresult 10 IXSLProcessor**>
	^self invalidCall: _failureCode!

get_stylesheet: stylesheet
	"Private - Get the value of the 'stylesheet' property of the receiver.

		HRESULT __stdcall stylesheet(
			[out, retval]IXMLDOMNode** stylesheet);"

	<virtual stdcall: hresult 9 IXMLDOMNode**>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

putref_stylesheet: stylesheet
	"Private - Set the value of the 'stylesheet' property of the object wrapped by the 
	 receiver to the <IXMLDOMNode*> argument, stylesheet.

		HRESULT __stdcall stylesheet(
			[in]IXMLDOMNode* stylesheet);"

	<virtual stdcall: hresult 8 IXMLDOMNode*>
	^self invalidCall: _failureCode!

setStylesheet: stylesheet
	"Set the 'stylesheet' property of the receiver to the <IXMLDOMNode*> value of the argument.
	Helpstring: stylesheet to use with processors"

	self putref_stylesheet: stylesheet!

stylesheet
	"Answer the <IXMLDOMNode> value of the 'stylesheet' property of the receiver.
	Helpstring: stylesheet to use with processors"

	| answer |
	answer := IXMLDOMNode newPointer.
	self get_stylesheet: answer.
	^answer asObject! !

!MSXML.IXSLTemplate categoriesForMethods!
createProcessor!**auto generated**!methods!public! !
CreateProcessor:!**auto generated**!COM Interfaces-IXSLTemplate!private! !
get_stylesheet:!**auto generated**!COM Interfaces-IXSLTemplate!private! !
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
putref_stylesheet:!**auto generated**!COM Interfaces-IXSLTemplate!private! !
setStylesheet:!**auto generated**!properties!public! !
stylesheet!**auto generated**!properties!public! !
!

!MSXML.IXSLTemplate class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (XSLTemplate60) for which the receiver is the default interface."

	^CLSID fromString: '{88d96a08-f192-11d4-a65f-0040963251e5}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXSLTemplate'
		IXSLTemplate defineTemplate"

	self
		defineFunction: #putref_stylesheet:
			argumentTypes: 'IXMLDOMNode*';
		defineFunction: #get_stylesheet:
			argumentTypes: 'IXMLDOMNode**';
		defineFunction: #CreateProcessor:
			argumentTypes: 'IXSLProcessor**'
! !

!MSXML.IXSLTemplate class categoriesForMethods!
clsid!**auto generated**!constants!private! !
defineFunctions!**auto generated**!initializing!private! !
!

