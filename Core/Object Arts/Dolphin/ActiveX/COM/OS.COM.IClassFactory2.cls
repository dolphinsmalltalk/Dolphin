﻿"Filed out from Dolphin Smalltalk"!

OS.COM.IClassFactory
	subclass: #'OS.COM.IClassFactory2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.IClassFactory2 guid: (OS.COM.IID fromString: '{b196b28f-bab4-101a-b69c-00aa00341d07}')!

OS.COM.IClassFactory2 comment: '`OS.COM.IClassFactory2` is a wrapper class for the custom interface ''OCIDL.IClassFactory2'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!

!OS.COM.IClassFactory2 categoriesForClass!COM-Interfaces! !

!OS.COM.IClassFactory2 methodsFor!

CreateInstanceLic: punkOuter pUnkReserved: pUnkReserved riid: riid bstrKey: bstrKey ppvObject: ppvObj
	"Invoke the CreateInstanceLic() method of the object wrapped by the receiver.
	
		HRESULT __stdcall CreateInstanceLic(
			[in] IUnknown* pUnkOuter,
			[in] IUnknown* pUnkReserved,
			[in] GUID* riid,
			[in] BSTR bstrKey,
			[out] IUnknown** ppvObj);

	"

	<virtual stdcall: hresult 8 IUnknown* IUnknown* guid* bstr IUnknown**>
	^self invalidCall: _failureCode!

getLicenseInfo
	| licinfo |
	licinfo := OS.COM.LICINFO newBuffer.
	self GetLicInfo: licinfo.
	^licinfo!

GetLicInfo: pLicInfo
	"Invoke the GetLicInfo() method of the object wrapped by the receiver.
	
		HRESULT __stdcall GetLicInfo(
			[out] LICINFO* pLicInfo);

	"

	<virtual stdcall: hresult 6 LICINFO*>
	^self invalidCall: _failureCode!

requestLicenseKey
	"Request a runtime license key"

	| license |
	license := BSTR new.
	self RequestLicKey: 0 pBstrKey: license.
	^license!

RequestLicKey: dwReserved pBstrKey: pBstrKey
	"Invoke the RequestLicKey() method of the object wrapped by the receiver.
	
		HRESULT __stdcall RequestLicKey(
			[in] unsigned long dwReserved,
			[out] BSTR* pBstrKey);

	"

	<virtual stdcall: hresult 7 uint32 bstr*>
	^self invalidCall: _failureCode! !

!OS.COM.IClassFactory2 categoriesForMethods!
CreateInstanceLic:pUnkReserved:riid:bstrKey:ppvObject:!**auto generated**!COM Interfaces-OCIDL.IClassFactory2!public! !
getLicenseInfo!accessing!public! !
GetLicInfo:!COM Interfaces-OCIDL.IClassFactory2!private! !
requestLicenseKey!accessing!enquiries!public! !
RequestLicKey:pBstrKey:!**auto generated**!COM Interfaces-OCIDL.IClassFactory2!private! !
!

!OS.COM.IClassFactory2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IClassFactory2'
		IClassFactory2 defineTemplate
	"

	self
		defineFunction: #GetLicInfo:
			argumentTypes: 'LICINFO*';
		defineFunction: #RequestLicKey:pBstrKey:
			argumentTypes: 'dword bstr*';
		defineFunction: #CreateInstanceLic:pUnkReserved:riid:bstrKey:ppvObject:
						argumentTypes: 'IUnknown* IUnknown* GUID* bstr IUnknown**'! !

!OS.COM.IClassFactory2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

