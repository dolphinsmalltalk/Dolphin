"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSXML.IMXXMLFilter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IMXXMLFilter guid: (OS.COM.IID fromString: '{c90352f7-643c-4fbc-bb23-e996eb2d51fd}')!
MSXML.IMXXMLFilter comment: '<IMXXMLFilter> is a wrapper class for the COM interface ''MSXML2.IMXXMLFilter'' generated from type information in the ''Microsoft XML, v6.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IMXXMLFilter interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(C90352F7-643C-4FBC-BB23-E996EB2D51FD), 
	helpstring("IMXXMLFilter interface"), 
	nonextensible, 
	dual
]
interface IMXXMLFilter : IDispatch
 {
	[id(0x0000058f)]
	HRESULT __stdcall getFeature(
		[in]BSTR strName,
		[out, retval]VARIANT_BOOL* fValue);
	[id(0x00000591)]
	HRESULT __stdcall putFeature(
		[in]BSTR strName,
		[in]VARIANT_BOOL fValue);
	[id(0x00000590)]
	HRESULT __stdcall getProperty(
		[in]BSTR strName,
		[out, retval]VARIANT* varValue);
	[id(0x00000592)]
	HRESULT __stdcall putProperty(
		[in]BSTR strName,
		[in]VARIANT varValue);
	[id(0x0000058d), propget]
	HRESULT __stdcall entityResolver(
		[out, retval]IUnknown** oResolver);
	[id(0x0000058d), propputref]
	HRESULT __stdcall entityResolver(
		[in]IUnknown* oResolver);
	[id(0x0000058b), propget]
	HRESULT __stdcall contentHandler(
		[out, retval]IUnknown** oHandler);
	[id(0x0000058b), propputref]
	HRESULT __stdcall contentHandler(
		[in]IUnknown* oHandler);
	[id(0x0000058c), propget]
	HRESULT __stdcall dtdHandler(
		[out, retval]IUnknown** oHandler);
	[id(0x0000058c), propputref]
	HRESULT __stdcall dtdHandler(
		[in]IUnknown* oHandler);
	[id(0x0000058e), propget]
	HRESULT __stdcall errorHandler(
		[out, retval]IUnknown** oHandler);
	[id(0x0000058e), propputref]
	HRESULT __stdcall errorHandler(
		[in]IUnknown* oHandler);
};
'!
!MSXML.IMXXMLFilter categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.IMXXMLFilter methodsFor!

contentHandler
	"Answer the <IUnknown> value of the 'contentHandler' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_contentHandler: answer.
	^answer asObject
!

dtdHandler
	"Answer the <IUnknown> value of the 'dtdHandler' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_dtdHandler: answer.
	^answer asObject
!

entityResolver
	"Answer the <IUnknown> value of the 'entityResolver' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_entityResolver: answer.
	^answer asObject
!

errorHandler
	"Answer the <IUnknown> value of the 'errorHandler' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_errorHandler: answer.
	^answer asObject
!

get_contentHandler: oHandler
	"Private - Get the value of the 'contentHandler' property of the receiver.

		HRESULT __stdcall contentHandler(
			[out, retval]IUnknown** oHandler);"

	<virtual stdcall: hresult 14 IUnknown**>
	^self invalidCall: _failureCode!

get_dtdHandler: oHandler
	"Private - Get the value of the 'dtdHandler' property of the receiver.

		HRESULT __stdcall dtdHandler(
			[out, retval]IUnknown** oHandler);"

	<virtual stdcall: hresult 16 IUnknown**>
	^self invalidCall: _failureCode!

get_entityResolver: oResolver
	"Private - Get the value of the 'entityResolver' property of the receiver.

		HRESULT __stdcall entityResolver(
			[out, retval]IUnknown** oResolver);"

	<virtual stdcall: hresult 12 IUnknown**>
	^self invalidCall: _failureCode!

get_errorHandler: oHandler
	"Private - Get the value of the 'errorHandler' property of the receiver.

		HRESULT __stdcall errorHandler(
			[out, retval]IUnknown** oHandler);"

	<virtual stdcall: hresult 18 IUnknown**>
	^self invalidCall: _failureCode!

getFeature: strName
	"Answer the <VARIANT_BOOL> result of invoking the getFeature() method of the COM object."

	| answer |
	answer := (VARIANT_BOOL new).
	self
		GetFeature: strName
		fValue: answer.
	^answer asObject
!

GetFeature: strName fValue: fValue
	"Private - Invoke the getFeature() method of the COM object.

		HRESULT __stdcall getFeature(
			[in]BSTR strName,
			[out, retval]VARIANT_BOOL* fValue);"

	<virtual stdcall: hresult 8 bstr varbool*>
	^self invalidCall: _failureCode!

GetProperty: strName varValue: varValue
	"Private - Invoke the getProperty() method of the COM object.

		HRESULT __stdcall getProperty(
			[in]BSTR strName,
			[out, retval]VARIANT* varValue);"

	<virtual stdcall: hresult 10 bstr variant*>
	^self invalidCall: _failureCode!

getProperty_: strName
	"Answer the <VARIANT> result of invoking the getProperty() method of the COM object."

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

PutFeature: strName fValue: fValue
	"Invoke the putFeature() method of the COM object.

		HRESULT __stdcall putFeature(
			[in]BSTR strName,
			[in]VARIANT_BOOL fValue);"

	<virtual stdcall: hresult 9 bstr varbool>
	^self invalidCall: _failureCode!

putProperty: strName varValue: varValue
	"Invoke the putProperty() method of the COM object."

	^self
		PutProperty: strName
		varValue: varValue asVariant
!

PutProperty: strName varValue: varValue
	"Private - Invoke the putProperty() method of the COM object.

		HRESULT __stdcall putProperty(
			[in]BSTR strName,
			[in]VARIANT varValue);"

	<virtual stdcall: hresult 11 bstr variant>
	^self invalidCall: _failureCode!

putref_contentHandler: oHandler
	"Private - Set the value of the 'contentHandler' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, oHandler.

		HRESULT __stdcall contentHandler(
			[in]IUnknown* oHandler);"

	<virtual stdcall: hresult 15 IUnknown*>
	^self invalidCall: _failureCode!

putref_dtdHandler: oHandler
	"Private - Set the value of the 'dtdHandler' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, oHandler.

		HRESULT __stdcall dtdHandler(
			[in]IUnknown* oHandler);"

	<virtual stdcall: hresult 17 IUnknown*>
	^self invalidCall: _failureCode!

putref_entityResolver: oResolver
	"Private - Set the value of the 'entityResolver' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, oResolver.

		HRESULT __stdcall entityResolver(
			[in]IUnknown* oResolver);"

	<virtual stdcall: hresult 13 IUnknown*>
	^self invalidCall: _failureCode!

putref_errorHandler: oHandler
	"Private - Set the value of the 'errorHandler' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, oHandler.

		HRESULT __stdcall errorHandler(
			[in]IUnknown* oHandler);"

	<virtual stdcall: hresult 19 IUnknown*>
	^self invalidCall: _failureCode!

setContentHandler: oHandler
	"Set the 'contentHandler' property of the receiver to the <IUnknown*> value of the argument."

	self putref_contentHandler: oHandler
!

setDtdHandler: oHandler
	"Set the 'dtdHandler' property of the receiver to the <IUnknown*> value of the argument."

	self putref_dtdHandler: oHandler
!

setEntityResolver: oResolver
	"Set the 'entityResolver' property of the receiver to the <IUnknown*> value of the argument."

	self putref_entityResolver: oResolver
!

setErrorHandler: oHandler
	"Set the 'errorHandler' property of the receiver to the <IUnknown*> value of the argument."

	self putref_errorHandler: oHandler
! !
!MSXML.IMXXMLFilter categoriesFor: #contentHandler!**auto generated**!properties!public! !
!MSXML.IMXXMLFilter categoriesFor: #dtdHandler!**auto generated**!properties!public! !
!MSXML.IMXXMLFilter categoriesFor: #entityResolver!**auto generated**!properties!public! !
!MSXML.IMXXMLFilter categoriesFor: #errorHandler!**auto generated**!properties!public! !
!MSXML.IMXXMLFilter categoriesFor: #get_contentHandler:!**auto generated**!COM Interfaces-IMXXMLFilter!private! !
!MSXML.IMXXMLFilter categoriesFor: #get_dtdHandler:!**auto generated**!COM Interfaces-IMXXMLFilter!private! !
!MSXML.IMXXMLFilter categoriesFor: #get_entityResolver:!**auto generated**!COM Interfaces-IMXXMLFilter!private! !
!MSXML.IMXXMLFilter categoriesFor: #get_errorHandler:!**auto generated**!COM Interfaces-IMXXMLFilter!private! !
!MSXML.IMXXMLFilter categoriesFor: #getFeature:!**auto generated**!methods!public! !
!MSXML.IMXXMLFilter categoriesFor: #GetFeature:fValue:!**auto generated**!COM Interfaces-IMXXMLFilter!private! !
!MSXML.IMXXMLFilter categoriesFor: #GetProperty:varValue:!**auto generated**!COM Interfaces-IMXXMLFilter!private! !
!MSXML.IMXXMLFilter categoriesFor: #getProperty_:!**auto generated**!methods!public! !
!MSXML.IMXXMLFilter categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSXML.IMXXMLFilter categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!MSXML.IMXXMLFilter categoriesFor: #PutFeature:fValue:!**auto generated**!COM Interfaces-IMXXMLFilter!public! !
!MSXML.IMXXMLFilter categoriesFor: #putProperty:varValue:!**auto generated**!methods!public! !
!MSXML.IMXXMLFilter categoriesFor: #PutProperty:varValue:!**auto generated**!COM Interfaces-IMXXMLFilter!private! !
!MSXML.IMXXMLFilter categoriesFor: #putref_contentHandler:!**auto generated**!COM Interfaces-IMXXMLFilter!private! !
!MSXML.IMXXMLFilter categoriesFor: #putref_dtdHandler:!**auto generated**!COM Interfaces-IMXXMLFilter!private! !
!MSXML.IMXXMLFilter categoriesFor: #putref_entityResolver:!**auto generated**!COM Interfaces-IMXXMLFilter!private! !
!MSXML.IMXXMLFilter categoriesFor: #putref_errorHandler:!**auto generated**!COM Interfaces-IMXXMLFilter!private! !
!MSXML.IMXXMLFilter categoriesFor: #setContentHandler:!**auto generated**!properties!public! !
!MSXML.IMXXMLFilter categoriesFor: #setDtdHandler:!**auto generated**!properties!public! !
!MSXML.IMXXMLFilter categoriesFor: #setEntityResolver:!**auto generated**!properties!public! !
!MSXML.IMXXMLFilter categoriesFor: #setErrorHandler:!**auto generated**!properties!public! !

!MSXML.IMXXMLFilter class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IMXXMLFilter'
		IMXXMLFilter defineTemplate"

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
			argumentTypes: 'IUnknown**';
		defineFunction: #putref_entityResolver:
			argumentTypes: 'IUnknown*';
		defineFunction: #get_contentHandler:
			argumentTypes: 'IUnknown**';
		defineFunction: #putref_contentHandler:
			argumentTypes: 'IUnknown*';
		defineFunction: #get_dtdHandler:
			argumentTypes: 'IUnknown**';
		defineFunction: #putref_dtdHandler:
			argumentTypes: 'IUnknown*';
		defineFunction: #get_errorHandler:
			argumentTypes: 'IUnknown**';
		defineFunction: #putref_errorHandler:
			argumentTypes: 'IUnknown*'
! !
!MSXML.IMXXMLFilter class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

