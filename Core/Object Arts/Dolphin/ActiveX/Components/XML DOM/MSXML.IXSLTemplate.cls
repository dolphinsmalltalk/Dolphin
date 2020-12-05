"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSXML.IXSLTemplate'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IXSLTemplate guid: (OS.COM.IID fromString: '{2933bf93-7b36-11d2-b20e-00c04f983e60}')!
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

	self putref_stylesheet: stylesheet
!

stylesheet
	"Answer the <IXMLDOMNode> value of the 'stylesheet' property of the receiver.
	Helpstring: stylesheet to use with processors"

	| answer |
	answer := IXMLDOMNode newPointer.
	self get_stylesheet: answer.
	^answer asObject! !
!MSXML.IXSLTemplate categoriesFor: #createProcessor!**auto generated**!methods!public! !
!MSXML.IXSLTemplate categoriesFor: #CreateProcessor:!**auto generated**!COM Interfaces-IXSLTemplate!private! !
!MSXML.IXSLTemplate categoriesFor: #get_stylesheet:!**auto generated**!COM Interfaces-IXSLTemplate!private! !
!MSXML.IXSLTemplate categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSXML.IXSLTemplate categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!MSXML.IXSLTemplate categoriesFor: #putref_stylesheet:!**auto generated**!COM Interfaces-IXSLTemplate!private! !
!MSXML.IXSLTemplate categoriesFor: #setStylesheet:!**auto generated**!properties!public! !
!MSXML.IXSLTemplate categoriesFor: #stylesheet!**auto generated**!properties!public! !

!MSXML.IXSLTemplate class methodsFor!

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
!

newXSLTemplate
	"Answer a new instance of the receiver on the XSLTemplate COM object"

	^self onCLSID: (CLSID fromString: '{2933BF94-7B36-11D2-B20E-00C04F983E60}')
!

newXSLTemplate26
	"Answer a new instance of the receiver on the XSLTemplate26 COM object"

	^self onCLSID: (CLSID fromString: '{F5078F21-C551-11D3-89B9-0000F81FE221}')
!

newXSLTemplate30
	"Answer a new instance of the receiver on the XSLTemplate30 COM object"

	^self onCLSID: (CLSID fromString: '{F5078F36-C551-11D3-89B9-0000F81FE221}')
!

newXSLTemplate40
	"Answer a new instance of the receiver on the XSLTemplate40 COM object"

	^self onCLSID: (CLSID fromString: '{88D969C3-F192-11D4-A65F-0040963251E5}')
!

newXSLTemplate60
	"Answer a new instance of the receiver on the XSLTemplate60 COM object"

	^self onCLSID: (CLSID fromString: '{88D96A08-F192-11D4-A65F-0040963251E5}')
! !
!MSXML.IXSLTemplate class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!MSXML.IXSLTemplate class categoriesFor: #newXSLTemplate!**auto generated**!instance creation!public! !
!MSXML.IXSLTemplate class categoriesFor: #newXSLTemplate26!**auto generated**!instance creation!public! !
!MSXML.IXSLTemplate class categoriesFor: #newXSLTemplate30!**auto generated**!instance creation!public! !
!MSXML.IXSLTemplate class categoriesFor: #newXSLTemplate40!**auto generated**!instance creation!public! !
!MSXML.IXSLTemplate class categoriesFor: #newXSLTemplate60!**auto generated**!instance creation!public! !

