"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'MSXML.ISAXXMLReader'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.ISAXXMLReader guid: (OS.COM.IID fromString: '{a4f96ed0-f829-476e-81c0-cdc7bd2a0802}')!
MSXML.ISAXXMLReader comment: '<ISAXXMLReader> is a wrapper class for the COM interface ''MSXML2.ISAXXMLReader'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISAXXMLReader interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(A4F96ED0-F829-476E-81C0-CDC7BD2A0802), 
	helpstring("ISAXXMLReader interface"), 
	hidden
]
interface ISAXXMLReader : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall getFeature(
		[in]unsigned short* pwchName,
		[out, retval]VARIANT_BOOL* pvfValue);
	[id(0x60010001)]
	HRESULT __stdcall putFeature(
		[in]unsigned short* pwchName,
		[in]VARIANT_BOOL vfValue);
	[id(0x60010002)]
	HRESULT __stdcall getProperty(
		[in]unsigned short* pwchName,
		[out, retval]VARIANT* pvarValue);
	[id(0x60010003)]
	HRESULT __stdcall putProperty(
		[in]unsigned short* pwchName,
		[in]VARIANT varValue);
	[id(0x60010004)]
	HRESULT __stdcall getEntityResolver(
		[out, retval]ISAXEntityResolver** ppResolver);
	[id(0x60010005)]
	HRESULT __stdcall putEntityResolver(
		[in]ISAXEntityResolver* pResolver);
	[id(0x60010006)]
	HRESULT __stdcall getContentHandler(
		[out, retval]ISAXContentHandler** ppHandler);
	[id(0x60010007)]
	HRESULT __stdcall putContentHandler(
		[in]ISAXContentHandler* pHandler);
	[id(0x60010008)]
	HRESULT __stdcall getDTDHandler(
		[out, retval]ISAXDTDHandler** ppHandler);
	[id(0x60010009)]
	HRESULT __stdcall putDTDHandler(
		[in]ISAXDTDHandler* pHandler);
	[id(0x6001000a)]
	HRESULT __stdcall getErrorHandler(
		[out, retval]ISAXErrorHandler** ppHandler);
	[id(0x6001000b)]
	HRESULT __stdcall putErrorHandler(
		[in]ISAXErrorHandler* pHandler);
	[id(0x6001000c)]
	HRESULT __stdcall getBaseURL(
		[out, retval]unsigned short** ppwchBaseUrl);
	[id(0x6001000d)]
	HRESULT __stdcall putBaseURL(
		[in]unsigned short* pwchBaseUrl);
	[id(0x6001000e)]
	HRESULT __stdcall getSecureBaseURL(
		[out, retval]unsigned short** ppwchSecureBaseUrl);
	[id(0x6001000f)]
	HRESULT __stdcall putSecureBaseURL(
		[in]unsigned short* pwchSecureBaseUrl);
	[id(0x60010010)]
	HRESULT __stdcall parse(
		[in]VARIANT varInput);
	[id(0x60010011)]
	HRESULT __stdcall parseURL(
		[in]unsigned short* pwchUrl);
};
'!
!MSXML.ISAXXMLReader categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.ISAXXMLReader methodsFor!

getBaseURL
	"Answer the <word> result of invoking the getBaseURL() method of the COM object."

	| answer |
	answer := WORD newBufferClass: TaskMemory.
	self GetBaseURL: answer.
	^answer asObject!

GetBaseURL: ppwchBaseUrl
	"Private - Invoke the getBaseURL() method of the COM object.

		HRESULT __stdcall getBaseURL(
			[out, retval]unsigned short** ppwchBaseUrl);"

	<virtual stdcall: hresult 16 word**>
	^self invalidCall: _failureCode!

getContentHandler
	"Answer the <ISAXContentHandler> result of invoking the getContentHandler() method of the COM object."

	| answer |
	answer := ISAXContentHandler newPointer.
	self GetContentHandler: answer.
	^answer asObject!

GetContentHandler: ppHandler
	"Private - Invoke the getContentHandler() method of the COM object.

		HRESULT __stdcall getContentHandler(
			[out, retval]ISAXContentHandler** ppHandler);"

	<virtual stdcall: hresult 10 ISAXContentHandler**>
	^self invalidCall: _failureCode!

getDTDHandler
	"Answer the <ISAXDTDHandler> result of invoking the getDTDHandler() method of the COM object."

	| answer |
	answer := ISAXDTDHandler newPointer.
	self GetDTDHandler: answer.
	^answer asObject!

GetDTDHandler: ppHandler
	"Private - Invoke the getDTDHandler() method of the COM object.

		HRESULT __stdcall getDTDHandler(
			[out, retval]ISAXDTDHandler** ppHandler);"

	<virtual stdcall: hresult 12 ISAXDTDHandler**>
	^self invalidCall: _failureCode!

getEntityResolver
	"Answer the <ISAXEntityResolver> result of invoking the getEntityResolver() method of the COM object."

	| answer |
	answer := ISAXEntityResolver newPointer.
	self GetEntityResolver: answer.
	^answer asObject!

GetEntityResolver: ppResolver
	"Private - Invoke the getEntityResolver() method of the COM object.

		HRESULT __stdcall getEntityResolver(
			[out, retval]ISAXEntityResolver** ppResolver);"

	<virtual stdcall: hresult 8 ISAXEntityResolver**>
	^self invalidCall: _failureCode!

getErrorHandler
	"Answer the <ISAXErrorHandler> result of invoking the getErrorHandler() method of the COM object."

	| answer |
	answer := ISAXErrorHandler newPointer.
	self GetErrorHandler: answer.
	^answer asObject!

GetErrorHandler: ppHandler
	"Private - Invoke the getErrorHandler() method of the COM object.

		HRESULT __stdcall getErrorHandler(
			[out, retval]ISAXErrorHandler** ppHandler);"

	<virtual stdcall: hresult 14 ISAXErrorHandler**>
	^self invalidCall: _failureCode!

getFeature: pwchName
	"Answer the <varbool> result of invoking the getFeature() method of the COM object."

	| answer |
	answer := VARIANT_BOOL new.
	self GetFeature: pwchName pvfValue: answer.
	^answer asObject!

GetFeature: pwchName pvfValue: pvfValue
	"Private - Invoke the getFeature() method of the COM object.

		HRESULT __stdcall getFeature(
			[in]unsigned short* pwchName,
			[out, retval]VARIANT_BOOL* pvfValue);"

	<virtual stdcall: hresult 4 word* varbool*>
	^self invalidCall: _failureCode!

getProperty: pwchName
	"Answer the <variant> result of invoking the getProperty() method of the COM object."

	| answer |
	answer := VARIANT new.
	self GetProperty: pwchName pvarValue: answer.
	^answer asObject!

GetProperty: pwchName pvarValue: pvarValue
	"Private - Invoke the getProperty() method of the COM object.

		HRESULT __stdcall getProperty(
			[in]unsigned short* pwchName,
			[out, retval]VARIANT* pvarValue);"

	<virtual stdcall: hresult 6 word* variant*>
	^self invalidCall: _failureCode!

getSecureBaseURL
	"Answer the <word> result of invoking the getSecureBaseURL() method of the COM object."

	| answer |
	answer := WORD newBufferClass: TaskMemory.
	self GetSecureBaseURL: answer.
	^answer asObject!

GetSecureBaseURL: ppwchSecureBaseUrl
	"Private - Invoke the getSecureBaseURL() method of the COM object.

		HRESULT __stdcall getSecureBaseURL(
			[out, retval]unsigned short** ppwchSecureBaseUrl);"

	<virtual stdcall: hresult 18 word**>
	^self invalidCall: _failureCode!

parse
	"Invoke the parse() method of the COM object.
	Default values are passed for all optional parameters."

	^self parse: VARIANT unspecified!

parse: varInput
	"Invoke the parse() method of the COM object."

	^self Parse: varInput asVariant!

Parse: varInput
	"Private - Invoke the parse() method of the COM object.

		HRESULT __stdcall parse(
			[in, optional]VARIANT varInput);"

	<virtual stdcall: hresult 20 variant>
	^self invalidCall: _failureCode!

ParseURL: pwchUrl
	"Invoke the parseURL() method of the COM object.

		HRESULT __stdcall parseURL(
			[in]unsigned short* pwchUrl);"

	<virtual stdcall: hresult 21 word*>
	^self invalidCall: _failureCode!

PutBaseURL: pwchBaseUrl
	"Invoke the putBaseURL() method of the COM object.

		HRESULT __stdcall putBaseURL(
			[in]unsigned short* pwchBaseUrl);"

	<virtual stdcall: hresult 17 word*>
	^self invalidCall: _failureCode!

PutContentHandler: pHandler
	"Invoke the putContentHandler() method of the COM object.

		HRESULT __stdcall putContentHandler(
			[in]ISAXContentHandler* pHandler);"

	<virtual stdcall: hresult 11 ISAXContentHandler*>
	^self invalidCall: _failureCode!

PutDTDHandler: pHandler
	"Invoke the putDTDHandler() method of the COM object.

		HRESULT __stdcall putDTDHandler(
			[in]ISAXDTDHandler* pHandler);"

	<virtual stdcall: hresult 13 ISAXDTDHandler*>
	^self invalidCall: _failureCode!

PutEntityResolver: pResolver
	"Invoke the putEntityResolver() method of the COM object.

		HRESULT __stdcall putEntityResolver(
			[in]ISAXEntityResolver* pResolver);"

	<virtual stdcall: hresult 9 ISAXEntityResolver*>
	^self invalidCall: _failureCode!

PutErrorHandler: pHandler
	"Invoke the putErrorHandler() method of the COM object.

		HRESULT __stdcall putErrorHandler(
			[in]ISAXErrorHandler* pHandler);"

	<virtual stdcall: hresult 15 ISAXErrorHandler*>
	^self invalidCall: _failureCode!

PutFeature: pwchName vfValue: vfValue
	"Invoke the putFeature() method of the COM object.

		HRESULT __stdcall putFeature(
			[in]unsigned short* pwchName,
			[in]VARIANT_BOOL vfValue);"

	<virtual stdcall: hresult 5 word* varbool>
	^self invalidCall: _failureCode!

putProperty: pwchName varValue: varValue
	"Invoke the putProperty() method of the COM object."

	^self PutProperty: pwchName varValue: varValue asVariant!

PutProperty: pwchName varValue: varValue
	"Private - Invoke the putProperty() method of the COM object.

		HRESULT __stdcall putProperty(
			[in]unsigned short* pwchName,
			[in]VARIANT varValue);"

	<virtual stdcall: hresult 7 word* variant>
	^self invalidCall: _failureCode!

PutSecureBaseURL: pwchSecureBaseUrl
	"Invoke the putSecureBaseURL() method of the COM object.

		HRESULT __stdcall putSecureBaseURL(
			[in]unsigned short* pwchSecureBaseUrl);"

	<virtual stdcall: hresult 19 word*>
	^self invalidCall: _failureCode! !
!MSXML.ISAXXMLReader categoriesFor: #getBaseURL!**auto generated**!methods!public! !
!MSXML.ISAXXMLReader categoriesFor: #GetBaseURL:!**auto generated**!COM Interfaces-ISAXXMLReader!private! !
!MSXML.ISAXXMLReader categoriesFor: #getContentHandler!**auto generated**!methods!public! !
!MSXML.ISAXXMLReader categoriesFor: #GetContentHandler:!**auto generated**!COM Interfaces-ISAXXMLReader!private! !
!MSXML.ISAXXMLReader categoriesFor: #getDTDHandler!**auto generated**!methods!public! !
!MSXML.ISAXXMLReader categoriesFor: #GetDTDHandler:!**auto generated**!COM Interfaces-ISAXXMLReader!private! !
!MSXML.ISAXXMLReader categoriesFor: #getEntityResolver!**auto generated**!methods!public! !
!MSXML.ISAXXMLReader categoriesFor: #GetEntityResolver:!**auto generated**!COM Interfaces-ISAXXMLReader!private! !
!MSXML.ISAXXMLReader categoriesFor: #getErrorHandler!**auto generated**!methods!public! !
!MSXML.ISAXXMLReader categoriesFor: #GetErrorHandler:!**auto generated**!COM Interfaces-ISAXXMLReader!private! !
!MSXML.ISAXXMLReader categoriesFor: #getFeature:!**auto generated**!methods!public! !
!MSXML.ISAXXMLReader categoriesFor: #GetFeature:pvfValue:!**auto generated**!COM Interfaces-ISAXXMLReader!private! !
!MSXML.ISAXXMLReader categoriesFor: #getProperty:!**auto generated**!methods!public! !
!MSXML.ISAXXMLReader categoriesFor: #GetProperty:pvarValue:!**auto generated**!COM Interfaces-ISAXXMLReader!private! !
!MSXML.ISAXXMLReader categoriesFor: #getSecureBaseURL!**auto generated**!methods!public! !
!MSXML.ISAXXMLReader categoriesFor: #GetSecureBaseURL:!**auto generated**!COM Interfaces-ISAXXMLReader!private! !
!MSXML.ISAXXMLReader categoriesFor: #parse!**auto generated**!methods!public! !
!MSXML.ISAXXMLReader categoriesFor: #parse:!**auto generated**!methods!public! !
!MSXML.ISAXXMLReader categoriesFor: #Parse:!**auto generated**!COM Interfaces-ISAXXMLReader!private! !
!MSXML.ISAXXMLReader categoriesFor: #ParseURL:!**auto generated**!COM Interfaces-ISAXXMLReader!public! !
!MSXML.ISAXXMLReader categoriesFor: #PutBaseURL:!**auto generated**!COM Interfaces-ISAXXMLReader!public! !
!MSXML.ISAXXMLReader categoriesFor: #PutContentHandler:!**auto generated**!COM Interfaces-ISAXXMLReader!public! !
!MSXML.ISAXXMLReader categoriesFor: #PutDTDHandler:!**auto generated**!COM Interfaces-ISAXXMLReader!public! !
!MSXML.ISAXXMLReader categoriesFor: #PutEntityResolver:!**auto generated**!COM Interfaces-ISAXXMLReader!public! !
!MSXML.ISAXXMLReader categoriesFor: #PutErrorHandler:!**auto generated**!COM Interfaces-ISAXXMLReader!public! !
!MSXML.ISAXXMLReader categoriesFor: #PutFeature:vfValue:!**auto generated**!COM Interfaces-ISAXXMLReader!public! !
!MSXML.ISAXXMLReader categoriesFor: #putProperty:varValue:!**auto generated**!methods!public! !
!MSXML.ISAXXMLReader categoriesFor: #PutProperty:varValue:!**auto generated**!COM Interfaces-ISAXXMLReader!private! !
!MSXML.ISAXXMLReader categoriesFor: #PutSecureBaseURL:!**auto generated**!COM Interfaces-ISAXXMLReader!public! !

!MSXML.ISAXXMLReader class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISAXXMLReader'
		ISAXXMLReader defineTemplate"

	self
		defineFunction: #GetFeature:pvfValue:
			argumentTypes: 'word* varbool*';
		defineFunction: #PutFeature:vfValue:
			argumentTypes: 'word* varbool';
		defineFunction: #GetProperty:pvarValue:
			argumentTypes: 'word* variant*';
		defineFunction: #PutProperty:varValue:
			argumentTypes: 'word* variant';
		defineFunction: #GetEntityResolver:
			argumentTypes: 'ISAXEntityResolver**';
		defineFunction: #PutEntityResolver:
			argumentTypes: 'ISAXEntityResolver*';
		defineFunction: #GetContentHandler:
			argumentTypes: 'ISAXContentHandler**';
		defineFunction: #PutContentHandler:
			argumentTypes: 'ISAXContentHandler*';
		defineFunction: #GetDTDHandler:
			argumentTypes: 'ISAXDTDHandler**';
		defineFunction: #PutDTDHandler:
			argumentTypes: 'ISAXDTDHandler*';
		defineFunction: #GetErrorHandler:
			argumentTypes: 'ISAXErrorHandler**';
		defineFunction: #PutErrorHandler:
			argumentTypes: 'ISAXErrorHandler*';
		defineFunction: #GetBaseURL:
			argumentTypes: 'word**';
		defineFunction: #PutBaseURL:
			argumentTypes: 'word*';
		defineFunction: #GetSecureBaseURL:
			argumentTypes: 'word**';
		defineFunction: #PutSecureBaseURL:
			argumentTypes: 'word*';
		defineFunction: #Parse:
			argumentTypes: 'variant';
		defineFunction: #ParseURL:
			argumentTypes: 'word*'
! !
!MSXML.ISAXXMLReader class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

