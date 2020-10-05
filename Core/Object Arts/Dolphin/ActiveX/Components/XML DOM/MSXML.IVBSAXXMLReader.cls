"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IVBSAXXMLReader
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
IVBSAXXMLReader guid: (IID fromString: '{8c033caa-6cd6-4f73-b728-4531af74945f}')!
IVBSAXXMLReader comment: '<IVBSAXXMLReader> is a wrapper class for the COM interface ''MSXML2.IVBSAXXMLReader'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IVBSAXXMLReader interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(8C033CAA-6CD6-4F73-B728-4531AF74945F), 
	helpstring("IVBSAXXMLReader interface"), 
	dual, 
	nonextensible
]
interface IVBSAXXMLReader : IDispatch
 {
	[id(0x00000502), helpstring("Look up the value of a feature.")]
	HRESULT __stdcall getFeature(
		[in]BSTR strName,
		[out, retval]VARIANT_BOOL* fValue);
	[id(0x00000503), helpstring("Set the state of a feature.")]
	HRESULT __stdcall putFeature(
		[in]BSTR strName,
		[in]VARIANT_BOOL fValue);
	[id(0x00000504), helpstring("Look up the value of a property.")]
	HRESULT __stdcall getProperty(
		[in]BSTR strName,
		[out, retval]VARIANT* varValue);
	[id(0x00000505), helpstring("Set the value of a property.")]
	HRESULT __stdcall putProperty(
		[in]BSTR strName,
		[in]VARIANT varValue);
	[id(0x00000506), propget, helpstring("Allow an application to register an entity resolver or look up the current entity resolver.")]
	HRESULT __stdcall entityResolver(
		[out, retval]IVBSAXEntityResolver** oResolver);
	[id(0x00000506), propputref, helpstring("Allow an application to register an entity resolver or look up the current entity resolver.")]
	HRESULT __stdcall entityResolver(
		[in]IVBSAXEntityResolver* oResolver);
	[id(0x00000507), propget, helpstring("Allow an application to register a content event handler or look up the current content event handler.")]
	HRESULT __stdcall contentHandler(
		[out, retval]IVBSAXContentHandler** oHandler);
	[id(0x00000507), propputref, helpstring("Allow an application to register a content event handler or look up the current content event handler.")]
	HRESULT __stdcall contentHandler(
		[in]IVBSAXContentHandler* oHandler);
	[id(0x00000508), propget, helpstring("Allow an application to register a DTD event handler or look up the current DTD event handler.")]
	HRESULT __stdcall dtdHandler(
		[out, retval]IVBSAXDTDHandler** oHandler);
	[id(0x00000508), propputref, helpstring("Allow an application to register a DTD event handler or look up the current DTD event handler.")]
	HRESULT __stdcall dtdHandler(
		[in]IVBSAXDTDHandler* oHandler);
	[id(0x00000509), propget, helpstring("Allow an application to register an error event handler or look up the current error event handler.")]
	HRESULT __stdcall errorHandler(
		[out, retval]IVBSAXErrorHandler** oHandler);
	[id(0x00000509), propputref, helpstring("Allow an application to register an error event handler or look up the current error event handler.")]
	HRESULT __stdcall errorHandler(
		[in]IVBSAXErrorHandler* oHandler);
	[id(0x0000050a), propget, helpstring("Set or get the base URL for the document.")]
	HRESULT __stdcall baseURL(
		[out, retval]BSTR* strBaseURL);
	[id(0x0000050a), propput, helpstring("Set or get the base URL for the document.")]
	HRESULT __stdcall baseURL(
		[in]BSTR strBaseURL);
	[id(0x0000050b), propget, helpstring("Set or get the secure base URL for the document.")]
	HRESULT __stdcall secureBaseURL(
		[out, retval]BSTR* strSecureBaseURL);
	[id(0x0000050b), propput, helpstring("Set or get the secure base URL for the document.")]
	HRESULT __stdcall secureBaseURL(
		[in]BSTR strSecureBaseURL);
	[id(0x0000050c), helpstring("Parse an XML document.")]
	HRESULT __stdcall parse(
		[in]VARIANT varInput);
	[id(0x0000050d), helpstring("Parse an XML document from a system identifier (URI).")]
	HRESULT __stdcall parseURL(
		[in]BSTR strURL);
};
'!
!IVBSAXXMLReader categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IVBSAXXMLReader methodsFor!

baseURL
	"Answer the <bstr> value of the 'baseURL' property of the receiver.
	Helpstring: Set or get the base URL for the document."

	| answer |
	answer := BSTR new.
	self get_baseURL: answer.
	^answer asObject
!

baseURL: strBaseURL
	"Set the 'baseURL' property of the receiver to the <bstr> value of the argument.
	Helpstring: Set or get the base URL for the document."

	self put_baseURL: strBaseURL
!

contentHandler
	"Answer the <IVBSAXContentHandler> value of the 'contentHandler' property of the receiver.
	Helpstring: Allow an application to register a content event handler or look up the current content event handler."

	| answer |
	answer := IVBSAXContentHandler newPointer.
	self get_contentHandler: answer.
	^answer asObject
!

dtdHandler
	"Answer the <IVBSAXDTDHandler> value of the 'dtdHandler' property of the receiver.
	Helpstring: Allow an application to register a DTD event handler or look up the current DTD event handler."

	| answer |
	answer := IVBSAXDTDHandler newPointer.
	self get_dtdHandler: answer.
	^answer asObject
!

entityResolver
	"Answer the <IVBSAXEntityResolver> value of the 'entityResolver' property of the receiver.
	Helpstring: Allow an application to register an entity resolver or look up the current entity resolver."

	| answer |
	answer := IVBSAXEntityResolver newPointer.
	self get_entityResolver: answer.
	^answer asObject
!

errorHandler
	"Answer the <IVBSAXErrorHandler> value of the 'errorHandler' property of the receiver.
	Helpstring: Allow an application to register an error event handler or look up the current error event handler."

	| answer |
	answer := IVBSAXErrorHandler newPointer.
	self get_errorHandler: answer.
	^answer asObject
!

get_baseURL: strBaseURL
	"Private - Get the value of the 'baseURL' property of the receiver.

		HRESULT __stdcall baseURL(
			[out, retval]BSTR* strBaseURL);"

	<virtual stdcall: hresult 20 bstr*>
	^self invalidCall: _failureCode!

get_contentHandler: oHandler
	"Private - Get the value of the 'contentHandler' property of the receiver.

		HRESULT __stdcall contentHandler(
			[out, retval]IVBSAXContentHandler** oHandler);"

	<virtual stdcall: hresult 14 IVBSAXContentHandler**>
	^self invalidCall: _failureCode!

get_dtdHandler: oHandler
	"Private - Get the value of the 'dtdHandler' property of the receiver.

		HRESULT __stdcall dtdHandler(
			[out, retval]IVBSAXDTDHandler** oHandler);"

	<virtual stdcall: hresult 16 IVBSAXDTDHandler**>
	^self invalidCall: _failureCode!

get_entityResolver: oResolver
	"Private - Get the value of the 'entityResolver' property of the receiver.

		HRESULT __stdcall entityResolver(
			[out, retval]IVBSAXEntityResolver** oResolver);"

	<virtual stdcall: hresult 12 IVBSAXEntityResolver**>
	^self invalidCall: _failureCode!

get_errorHandler: oHandler
	"Private - Get the value of the 'errorHandler' property of the receiver.

		HRESULT __stdcall errorHandler(
			[out, retval]IVBSAXErrorHandler** oHandler);"

	<virtual stdcall: hresult 18 IVBSAXErrorHandler**>
	^self invalidCall: _failureCode!

get_secureBaseURL: strSecureBaseURL
	"Private - Get the value of the 'secureBaseURL' property of the receiver.

		HRESULT __stdcall secureBaseURL(
			[out, retval]BSTR* strSecureBaseURL);"

	<virtual stdcall: hresult 22 bstr*>
	^self invalidCall: _failureCode!

getFeature: strName
	"Answer the <VARIANT_BOOL> result of invoking the getFeature() method of the COM object.
	Helpstring: Look up the value of a feature."

	| answer |
	answer := (VARIANT_BOOL new).
	self
		GetFeature: strName
		fValue: answer.
	^answer asObject
!

GetFeature: strName fValue: fValue
	"Private - Invoke the getFeature() method of the COM object.
	Helpstring: Look up the value of a feature.

		HRESULT __stdcall getFeature(
			[in]BSTR strName,
			[out, retval]VARIANT_BOOL* fValue);"

	<virtual stdcall: hresult 8 bstr varbool*>
	^self invalidCall: _failureCode!

GetProperty: strName varValue: varValue
	"Private - Invoke the getProperty() method of the COM object.
	Helpstring: Look up the value of a property.

		HRESULT __stdcall getProperty(
			[in]BSTR strName,
			[out, retval]VARIANT* varValue);"

	<virtual stdcall: hresult 10 bstr variant*>
	^self invalidCall: _failureCode!

getProperty_: strName
	"Answer the <VARIANT> result of invoking the getProperty() method of the COM object.
	Helpstring: Look up the value of a property."

	| answer |
	answer := VARIANT new.
	self
		GetProperty: strName
		varValue: answer.
	^answer asObject
!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

parse
	"Invoke the parse() method of the COM object.
	Default values are passed for all optional parameters."

	^self parse: VARIANT unspecified!

parse: varInput
	"Invoke the parse() method of the COM object.
	Helpstring: Parse an XML document."

	^self Parse: varInput asVariant
!

Parse: varInput
	"Private - Invoke the parse() method of the COM object.
	Helpstring: Parse an XML document.

		HRESULT __stdcall parse(
			[in, optional]VARIANT varInput);"

	<virtual stdcall: hresult 24 variant>
	^self invalidCall: _failureCode!

ParseURL: strURL
	"Invoke the parseURL() method of the COM object.
	Helpstring: Parse an XML document from a system identifier (URI).

		HRESULT __stdcall parseURL(
			[in]BSTR strURL);"

	<virtual stdcall: hresult 25 bstr>
	^self invalidCall: _failureCode!

put_baseURL: strBaseURL
	"Private - Set the value of the 'baseURL' property of the object wrapped by the 
	 receiver to the <bstr> argument, strBaseURL.

		HRESULT __stdcall baseURL(
			[in]BSTR strBaseURL);"

	<virtual stdcall: hresult 21 bstr>
	^self invalidCall: _failureCode!

put_secureBaseURL: strSecureBaseURL
	"Private - Set the value of the 'secureBaseURL' property of the object wrapped by the 
	 receiver to the <bstr> argument, strSecureBaseURL.

		HRESULT __stdcall secureBaseURL(
			[in]BSTR strSecureBaseURL);"

	<virtual stdcall: hresult 23 bstr>
	^self invalidCall: _failureCode!

PutFeature: strName fValue: fValue
	"Invoke the putFeature() method of the COM object.
	Helpstring: Set the state of a feature.

		HRESULT __stdcall putFeature(
			[in]BSTR strName,
			[in]VARIANT_BOOL fValue);"

	<virtual stdcall: hresult 9 bstr varbool>
	^self invalidCall: _failureCode!

putProperty: strName varValue: varValue
	"Invoke the putProperty() method of the COM object.
	Helpstring: Set the value of a property."

	^self
		PutProperty: strName
		varValue: varValue asVariant
!

PutProperty: strName varValue: varValue
	"Private - Invoke the putProperty() method of the COM object.
	Helpstring: Set the value of a property.

		HRESULT __stdcall putProperty(
			[in]BSTR strName,
			[in]VARIANT varValue);"

	<virtual stdcall: hresult 11 bstr variant>
	^self invalidCall: _failureCode!

putref_contentHandler: oHandler
	"Private - Set the value of the 'contentHandler' property of the object wrapped by the 
	 receiver to the <IVBSAXContentHandler*> argument, oHandler.

		HRESULT __stdcall contentHandler(
			[in]IVBSAXContentHandler* oHandler);"

	<virtual stdcall: hresult 15 IVBSAXContentHandler*>
	^self invalidCall: _failureCode!

putref_dtdHandler: oHandler
	"Private - Set the value of the 'dtdHandler' property of the object wrapped by the 
	 receiver to the <IVBSAXDTDHandler*> argument, oHandler.

		HRESULT __stdcall dtdHandler(
			[in]IVBSAXDTDHandler* oHandler);"

	<virtual stdcall: hresult 17 IVBSAXDTDHandler*>
	^self invalidCall: _failureCode!

putref_entityResolver: oResolver
	"Private - Set the value of the 'entityResolver' property of the object wrapped by the 
	 receiver to the <IVBSAXEntityResolver*> argument, oResolver.

		HRESULT __stdcall entityResolver(
			[in]IVBSAXEntityResolver* oResolver);"

	<virtual stdcall: hresult 13 IVBSAXEntityResolver*>
	^self invalidCall: _failureCode!

putref_errorHandler: oHandler
	"Private - Set the value of the 'errorHandler' property of the object wrapped by the 
	 receiver to the <IVBSAXErrorHandler*> argument, oHandler.

		HRESULT __stdcall errorHandler(
			[in]IVBSAXErrorHandler* oHandler);"

	<virtual stdcall: hresult 19 IVBSAXErrorHandler*>
	^self invalidCall: _failureCode!

secureBaseURL
	"Answer the <bstr> value of the 'secureBaseURL' property of the receiver.
	Helpstring: Set or get the secure base URL for the document."

	| answer |
	answer := BSTR new.
	self get_secureBaseURL: answer.
	^answer asObject
!

secureBaseURL: strSecureBaseURL
	"Set the 'secureBaseURL' property of the receiver to the <bstr> value of the argument.
	Helpstring: Set or get the secure base URL for the document."

	self put_secureBaseURL: strSecureBaseURL
!

setContentHandler: oHandler
	"Set the 'contentHandler' property of the receiver to the <IVBSAXContentHandler*> value of the argument.
	Helpstring: Allow an application to register a content event handler or look up the current content event handler."

	self putref_contentHandler: oHandler
!

setDtdHandler: oHandler
	"Set the 'dtdHandler' property of the receiver to the <IVBSAXDTDHandler*> value of the argument.
	Helpstring: Allow an application to register a DTD event handler or look up the current DTD event handler."

	self putref_dtdHandler: oHandler
!

setEntityResolver: oResolver
	"Set the 'entityResolver' property of the receiver to the <IVBSAXEntityResolver*> value of the argument.
	Helpstring: Allow an application to register an entity resolver or look up the current entity resolver."

	self putref_entityResolver: oResolver
!

setErrorHandler: oHandler
	"Set the 'errorHandler' property of the receiver to the <IVBSAXErrorHandler*> value of the argument.
	Helpstring: Allow an application to register an error event handler or look up the current error event handler."

	self putref_errorHandler: oHandler
! !
!IVBSAXXMLReader categoriesFor: #baseURL!**auto generated**!properties!public! !
!IVBSAXXMLReader categoriesFor: #baseURL:!**auto generated**!properties!public! !
!IVBSAXXMLReader categoriesFor: #contentHandler!**auto generated**!properties!public! !
!IVBSAXXMLReader categoriesFor: #dtdHandler!**auto generated**!properties!public! !
!IVBSAXXMLReader categoriesFor: #entityResolver!**auto generated**!properties!public! !
!IVBSAXXMLReader categoriesFor: #errorHandler!**auto generated**!properties!public! !
!IVBSAXXMLReader categoriesFor: #get_baseURL:!**auto generated**!COM Interfaces-IVBSAXXMLReader!private! !
!IVBSAXXMLReader categoriesFor: #get_contentHandler:!**auto generated**!COM Interfaces-IVBSAXXMLReader!private! !
!IVBSAXXMLReader categoriesFor: #get_dtdHandler:!**auto generated**!COM Interfaces-IVBSAXXMLReader!private! !
!IVBSAXXMLReader categoriesFor: #get_entityResolver:!**auto generated**!COM Interfaces-IVBSAXXMLReader!private! !
!IVBSAXXMLReader categoriesFor: #get_errorHandler:!**auto generated**!COM Interfaces-IVBSAXXMLReader!private! !
!IVBSAXXMLReader categoriesFor: #get_secureBaseURL:!**auto generated**!COM Interfaces-IVBSAXXMLReader!private! !
!IVBSAXXMLReader categoriesFor: #getFeature:!**auto generated**!methods!public! !
!IVBSAXXMLReader categoriesFor: #GetFeature:fValue:!**auto generated**!COM Interfaces-IVBSAXXMLReader!private! !
!IVBSAXXMLReader categoriesFor: #GetProperty:varValue:!**auto generated**!COM Interfaces-IVBSAXXMLReader!private! !
!IVBSAXXMLReader categoriesFor: #getProperty_:!**auto generated**!methods!public! !
!IVBSAXXMLReader categoriesFor: #isExtensible!**auto generated**!public!testing! !
!IVBSAXXMLReader categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!IVBSAXXMLReader categoriesFor: #parse!**auto generated**!methods!public! !
!IVBSAXXMLReader categoriesFor: #parse:!**auto generated**!methods!public! !
!IVBSAXXMLReader categoriesFor: #Parse:!**auto generated**!COM Interfaces-IVBSAXXMLReader!private! !
!IVBSAXXMLReader categoriesFor: #ParseURL:!**auto generated**!COM Interfaces-IVBSAXXMLReader!public! !
!IVBSAXXMLReader categoriesFor: #put_baseURL:!**auto generated**!COM Interfaces-IVBSAXXMLReader!private! !
!IVBSAXXMLReader categoriesFor: #put_secureBaseURL:!**auto generated**!COM Interfaces-IVBSAXXMLReader!private! !
!IVBSAXXMLReader categoriesFor: #PutFeature:fValue:!**auto generated**!COM Interfaces-IVBSAXXMLReader!public! !
!IVBSAXXMLReader categoriesFor: #putProperty:varValue:!**auto generated**!methods!public! !
!IVBSAXXMLReader categoriesFor: #PutProperty:varValue:!**auto generated**!COM Interfaces-IVBSAXXMLReader!private! !
!IVBSAXXMLReader categoriesFor: #putref_contentHandler:!**auto generated**!COM Interfaces-IVBSAXXMLReader!private! !
!IVBSAXXMLReader categoriesFor: #putref_dtdHandler:!**auto generated**!COM Interfaces-IVBSAXXMLReader!private! !
!IVBSAXXMLReader categoriesFor: #putref_entityResolver:!**auto generated**!COM Interfaces-IVBSAXXMLReader!private! !
!IVBSAXXMLReader categoriesFor: #putref_errorHandler:!**auto generated**!COM Interfaces-IVBSAXXMLReader!private! !
!IVBSAXXMLReader categoriesFor: #secureBaseURL!**auto generated**!properties!public! !
!IVBSAXXMLReader categoriesFor: #secureBaseURL:!**auto generated**!properties!public! !
!IVBSAXXMLReader categoriesFor: #setContentHandler:!**auto generated**!properties!public! !
!IVBSAXXMLReader categoriesFor: #setDtdHandler:!**auto generated**!properties!public! !
!IVBSAXXMLReader categoriesFor: #setEntityResolver:!**auto generated**!properties!public! !
!IVBSAXXMLReader categoriesFor: #setErrorHandler:!**auto generated**!properties!public! !

!IVBSAXXMLReader class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IVBSAXXMLReader'
		IVBSAXXMLReader defineTemplate"

	self
		defineFunction: #GetFeature:fValue:
			argumentTypes: 'bstr varbool*';
		defineFunction: #PutFeature:fValue:
			argumentTypes: 'bstr varbool';
		defineFunction: #GetProperty:varValue:
			argumentTypes: 'bstr variant*';
		defineFunction: #PutProperty:varValue:
			argumentTypes: 'bstr variant';
		defineFunction: #get_entityResolver:
			argumentTypes: 'IVBSAXEntityResolver**';
		defineFunction: #putref_entityResolver:
			argumentTypes: 'IVBSAXEntityResolver*';
		defineFunction: #get_contentHandler:
			argumentTypes: 'IVBSAXContentHandler**';
		defineFunction: #putref_contentHandler:
			argumentTypes: 'IVBSAXContentHandler*';
		defineFunction: #get_dtdHandler:
			argumentTypes: 'IVBSAXDTDHandler**';
		defineFunction: #putref_dtdHandler:
			argumentTypes: 'IVBSAXDTDHandler*';
		defineFunction: #get_errorHandler:
			argumentTypes: 'IVBSAXErrorHandler**';
		defineFunction: #putref_errorHandler:
			argumentTypes: 'IVBSAXErrorHandler*';
		defineFunction: #get_baseURL:
			argumentTypes: 'bstr*';
		defineFunction: #put_baseURL:
			argumentTypes: 'bstr';
		defineFunction: #get_secureBaseURL:
			argumentTypes: 'bstr*';
		defineFunction: #put_secureBaseURL:
			argumentTypes: 'bstr';
		defineFunction: #Parse:
			argumentTypes: 'variant';
		defineFunction: #ParseURL:
			argumentTypes: 'bstr'
!

newSAXXMLReader
	"Answer a new instance of the receiver on the SAXXMLReader COM object"

	^self onCLSID: (CLSID fromString: '{079AA557-4A18-424A-8EEE-E39F0A8D41B9}')
!

newSAXXMLReader30
	"Answer a new instance of the receiver on the SAXXMLReader30 COM object"

	^self onCLSID: (CLSID fromString: '{3124C396-FB13-4836-A6AD-1317F1713688}')
!

newSAXXMLReader40
	"Answer a new instance of the receiver on the SAXXMLReader40 COM object"

	^self onCLSID: (CLSID fromString: '{7C6E29BC-8B8B-4C3D-859E-AF6CD158BE0F}')
!

newSAXXMLReader60
	"Answer a new instance of the receiver on the SAXXMLReader60 COM object"

	^self onCLSID: (CLSID fromString: '{88D96A0C-F192-11D4-A65F-0040963251E5}')
! !
!IVBSAXXMLReader class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IVBSAXXMLReader class categoriesFor: #newSAXXMLReader!**auto generated**!instance creation!public! !
!IVBSAXXMLReader class categoriesFor: #newSAXXMLReader30!**auto generated**!instance creation!public! !
!IVBSAXXMLReader class categoriesFor: #newSAXXMLReader40!**auto generated**!instance creation!public! !
!IVBSAXXMLReader class categoriesFor: #newSAXXMLReader60!**auto generated**!instance creation!public! !

