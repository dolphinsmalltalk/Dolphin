"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'UI.IDolphinAxHost'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM private})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.IDolphinAxHost guid: (OS.COM.IID fromString: '{4ea0745e-6c01-4bb4-b0ae-47a53ba9174a}')!
UI.IDolphinAxHost comment: '<IDolphinAxHost> is a wrapper class for the COM interface ''ActiveXHost.IDolphinAxHost'' generated from type information in the ''Dolphin Smalltalk Active-X Host Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(4EA0745E-6C01-4BB4-B0AE-47A53BA9174A)
]
interface IDolphinAxHost : IUnknown {
	[id(0x60010000)] 
	HRESULT __stdcall SetExternalDispatch(
		[in] IDispatch* pDisp);
	[id(0x60010001)] 
	HRESULT __stdcall SetExternalUIHandler(
		[in] IDocHostUIHandlerDispatch* pDisp);
	[id(0x60010002)] 
	HRESULT __stdcall QueryControl(
		[in] GUID* riid,
		[out] IUnknown** ppiObject);
	[id(0x60010003)] 
	HRESULT __stdcall CreateControlLicEx(
		[in] LPWSTR lpTricsData,
		[in] ExternalHandle hWnd,
		[in] IStream* pStream,
		[out] IUnknown** ppUnk,
		[in] IPropertyNotifySink* piAdvise,
		[in] BSTR bstrLic);
	[id(0x60010004), propget, helpstring("Is the control being hosted windowless or not?")] 
	HRESULT __stdcall IsWindowless(
		[out, retval] VARIANT_BOOL* pbIsWindowless);
};
'!
!UI.IDolphinAxHost categoriesForClass!ActiveXHost-Interfaces!COM-Interfaces! !
!UI.IDolphinAxHost methodsFor!

createControlLicEx: lpTricsData hWnd: hWnd pStream: pStream piAdvise: piAdvise bstrLic: bstrLic
	"Answer the <IUnknown> result of invoking the CreateControlLicEx() method of the COM object."

	| answer |
	answer := IUnknown newPointer.
	self
		CreateControlLicEx: lpTricsData asUtf16String
		hWnd: hWnd
		pStream: pStream
		ppUnk: answer
		piAdvise: piAdvise
		bstrLic: bstrLic.
	^answer asObject!

CreateControlLicEx: lpTricsData hWnd: hWnd pStream: pStream ppUnk: ppUnk piAdvise: piAdvise bstrLic: bstrLic
	"Private - Invoke the CreateControlLicEx() method of the COM object.

		HRESULT __stdcall CreateControlLicEx(
			[in] LPWSTR lpTricsData,
			[in] ExternalHandle hWnd,
			[in] IStream* pStream,
			[out] IUnknown** ppUnk,
			[in] IPropertyNotifySink* piAdvise,
			[in] BSTR bstrLic);"

	<virtual stdcall: hresult 7 lpwstr handle IStream* IUnknown** IPropertyNotifySink* bstr>
	^self invalidCall: _failureCode!

get_IsWindowless: pbIsWindowless
	"Private - Get the value of the 'IsWindowless' property of the receiver.

		HRESULT __stdcall IsWindowless(
			[out, retval] VARIANT_BOOL* pbIsWindowless);"

	<virtual stdcall: hresult 8 varbool*>
	^self invalidCall: _failureCode!

isWindowless
	"Answer the <varbool> value of the 'IsWindowless' property of the receiver.
	Helpstring: Is the control being hosted windowless or not?"

	| answer |
	answer := VARIANT_BOOL new.
	self get_IsWindowless: answer.
	^answer asObject!

queryControl: riid
	"Answer the <IUnknown> result of invoking the QueryControl() method of the COM object."

	| answer |
	answer := IUnknown newPointer.
	self QueryControl: riid ppiObject: answer.
	^answer asObject!

QueryControl: riid ppiObject: ppiObject
	"Private - Invoke the QueryControl() method of the COM object.

		HRESULT __stdcall QueryControl(
			[in] GUID* riid,
			[out] IUnknown** ppiObject);"

	<virtual stdcall: hresult 6 guid* IUnknown**>
	^self invalidCall: _failureCode!

SetExternalDispatch: pDisp
	"Invoke the SetExternalDispatch() method of the COM object.

		HRESULT __stdcall SetExternalDispatch(
			[in] IDispatch* pDisp);"

	<virtual stdcall: hresult 4 IDispatch*>
	^self invalidCall: _failureCode!

SetExternalUIHandler: pDisp
	"Invoke the SetExternalUIHandler() method of the COM object.

		HRESULT __stdcall SetExternalUIHandler(
			[in] IDocHostUIHandlerDispatch* pDisp);"

	<virtual stdcall: hresult 5 IDocHostUIHandlerDispatch*>
	^self invalidCall: _failureCode! !
!UI.IDolphinAxHost categoriesFor: #createControlLicEx:hWnd:pStream:piAdvise:bstrLic:!**auto generated**!methods!public! !
!UI.IDolphinAxHost categoriesFor: #CreateControlLicEx:hWnd:pStream:ppUnk:piAdvise:bstrLic:!**auto generated**!COM Interfaces-IDolphinAxHost!private! !
!UI.IDolphinAxHost categoriesFor: #get_IsWindowless:!**auto generated**!COM Interfaces-IDolphinAxHost!private! !
!UI.IDolphinAxHost categoriesFor: #isWindowless!**auto generated**!properties!public! !
!UI.IDolphinAxHost categoriesFor: #queryControl:!**auto generated**!methods!public! !
!UI.IDolphinAxHost categoriesFor: #QueryControl:ppiObject:!**auto generated**!COM Interfaces-IDolphinAxHost!private! !
!UI.IDolphinAxHost categoriesFor: #SetExternalDispatch:!**auto generated**!COM Interfaces-IDolphinAxHost!public! !
!UI.IDolphinAxHost categoriesFor: #SetExternalUIHandler:!**auto generated**!COM Interfaces-IDolphinAxHost!public! !

!UI.IDolphinAxHost class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ActiveXHost.IDolphinAxHost'
		IDolphinAxHost defineTemplate"

	self
		defineFunction: #SetExternalDispatch:
			argumentTypes: 'IDispatch*';
		defineFunction: #SetExternalUIHandler:
			argumentTypes: 'IDocHostUIHandlerDispatch*';
		defineFunction: #QueryControl:ppiObject:
			argumentTypes: 'GUID* IUnknown**';
		defineFunction: #CreateControlLicEx:hWnd:pStream:ppUnk:piAdvise:bstrLic:
			argumentTypes: 'lpwstr handle IStream* IUnknown** IPropertyNotifySink* bstr';
		defineFunction: #get_IsWindowless:
			argumentTypes: 'varbool*'
! !
!UI.IDolphinAxHost class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

