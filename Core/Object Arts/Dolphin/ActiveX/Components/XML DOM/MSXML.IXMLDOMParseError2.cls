"Filed out from Dolphin Smalltalk 7"!

MSXML.IXMLDOMParseError subclass: #'MSXML.IXMLDOMParseError2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IXMLDOMParseError2 guid: (OS.COM.IID fromString: '{3efaa428-272f-11d2-836f-0000f87a7782}')!
MSXML.IXMLDOMParseError2 comment: '<IXMLDOMParseError2> is a wrapper class for the COM interface ''MSXML2.IXMLDOMParseError2'' generated from type information in the ''Microsoft XML, v6.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"structure for reporting parser errors"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(3EFAA428-272F-11D2-836F-0000F87A7782), 
	helpstring("structure for reporting parser errors"), 
	nonextensible, 
	dual
]
interface IXMLDOMParseError2 : IXMLDOMParseError
 {
	[id(0x000000be), propget]
	HRESULT __stdcall errorXPath(
		[out, retval]BSTR* xpathexpr);
	[id(0x000000bb), propget]
	HRESULT __stdcall allErrors(
		[out, retval]IXMLDOMParseErrorCollection** allErrors);
	[id(0x000000bc)]
	HRESULT __stdcall errorParameters(
		[in]long index,
		[out, retval]BSTR* param);
	[id(0x000000bd), propget]
	HRESULT __stdcall errorParametersCount(
		[out, retval]long* count);
};
'!
!MSXML.IXMLDOMParseError2 categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.IXMLDOMParseError2 methodsFor!

allErrors
	"Answer the <IXMLDOMParseErrorCollection> value of the 'allErrors' property of the receiver."

	| answer |
	answer := IXMLDOMParseErrorCollection newPointer.
	self get_allErrors: answer.
	^answer asObject!

errorParameters: index
	"Answer the <bstr> result of invoking the errorParameters() method of the COM object."

	| answer |
	answer := BSTR new.
	self ErrorParameters: index param: answer.
	^answer asObject!

ErrorParameters: index param: param
	"Private - Invoke the errorParameters() method of the COM object.

		HRESULT __stdcall errorParameters(
			[in]long index,
			[out, retval]BSTR* param);"

	<virtual stdcall: hresult 17 sdword bstr*>
	^self invalidCall: _failureCode!

errorParametersCount
	"Answer the <sdword> value of the 'errorParametersCount' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_errorParametersCount: answer.
	^answer asObject!

errorXPath
	"Answer the <bstr> value of the 'errorXPath' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_errorXPath: answer.
	^answer asObject!

get_allErrors: allErrors
	"Private - Get the value of the 'allErrors' property of the receiver.

		HRESULT __stdcall allErrors(
			[out, retval]IXMLDOMParseErrorCollection** allErrors);"

	<virtual stdcall: hresult 16 IXMLDOMParseErrorCollection**>
	^self invalidCall: _failureCode!

get_errorParametersCount: count
	"Private - Get the value of the 'errorParametersCount' property of the receiver.

		HRESULT __stdcall errorParametersCount(
			[out, retval]long* count);"

	<virtual stdcall: hresult 18 sdword*>
	^self invalidCall: _failureCode!

get_errorXPath: xpathexpr
	"Private - Get the value of the 'errorXPath' property of the receiver.

		HRESULT __stdcall errorXPath(
			[out, retval]BSTR* xpathexpr);"

	<virtual stdcall: hresult 15 bstr*>
	^self invalidCall: _failureCode! !
!MSXML.IXMLDOMParseError2 categoriesFor: #allErrors!**auto generated**!properties!public! !
!MSXML.IXMLDOMParseError2 categoriesFor: #errorParameters:!**auto generated**!methods!public! !
!MSXML.IXMLDOMParseError2 categoriesFor: #ErrorParameters:param:!**auto generated**!COM Interfaces-IXMLDOMParseError2!private! !
!MSXML.IXMLDOMParseError2 categoriesFor: #errorParametersCount!**auto generated**!properties!public! !
!MSXML.IXMLDOMParseError2 categoriesFor: #errorXPath!**auto generated**!properties!public! !
!MSXML.IXMLDOMParseError2 categoriesFor: #get_allErrors:!**auto generated**!COM Interfaces-IXMLDOMParseError2!private! !
!MSXML.IXMLDOMParseError2 categoriesFor: #get_errorParametersCount:!**auto generated**!COM Interfaces-IXMLDOMParseError2!private! !
!MSXML.IXMLDOMParseError2 categoriesFor: #get_errorXPath:!**auto generated**!COM Interfaces-IXMLDOMParseError2!private! !

!MSXML.IXMLDOMParseError2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMParseError2'
		IXMLDOMParseError2 defineTemplate"

	self
		defineFunction: #get_errorXPath:
			argumentTypes: 'bstr*';
		defineFunction: #get_allErrors:
			argumentTypes: 'IXMLDOMParseErrorCollection**';
		defineFunction: #ErrorParameters:param:
			argumentTypes: 'sdword bstr*';
		defineFunction: #get_errorParametersCount:
			argumentTypes: 'sdword*'
! !
!MSXML.IXMLDOMParseError2 class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

