"Filed out from Dolphin Smalltalk"!

IUnknown subclass: #IBindStatusCallback
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IBindStatusCallback guid: (IID fromString: '{79eac9c1-baf9-11ce-8c82-00aa004ba90b}')!
IBindStatusCallback comment: '<IBindStatusCallback> is a wrapper class for the COM interface ''OCIDL.IBindStatusCallback'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

This is a callback interface to be passed to IBindHost.MonikerBindToObject or IBindHost.MonikerBindToStorage.'!
!IBindStatusCallback categoriesForClass!COM-Interfaces! !
!IBindStatusCallback methodsFor!

GetBindInfo: grfBINDF pbindinfo: pbindinfo
	"Private - Invoke the GetBindInfo() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetBindInfo(
			[out] unsigned long* grfBINDF,
			[in, out] BINDINFO* pbindinfo);
	"

	<virtual stdcall: hresult 9 dword* BINDINFO*>
	^self invalidCall: _failureCode
!

GetPriority: pnPriority
	"Private - Invoke the GetPriority() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetPriority(
			[out] long* pnPriority);
	"

	<virtual stdcall: hresult 5 sdword*>
	^self invalidCall: _failureCode!

OnDataAvailable: grfBSCF dwSize: dwSize pFormatetc: pFormatetc pStgmed: pStgmed
	"Private - Invoke the OnDataAvailable() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnDataAvailable(
			[in] unsigned long grfBSCF,
			[in] unsigned long dwSize,
			[in] FORMATETC* pFormatetc,
			[in] STGMEDIUM* pStgmed);
	"

	<virtual stdcall: hresult 10 dword dword FORMATETC* STGMEDIUM*>
	^self invalidCall: _failureCode
!

OnLowResource: reserved
	"Private - Invoke the OnLowResource() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnLowResource(
			[in] unsigned long reserved);
	"

	<virtual stdcall: hresult 6 dword>
	^self invalidCall: _failureCode
!

OnObjectAvailable: riid pUnk: pUnk
	"Private - Invoke the OnObjectAvailable() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnObjectAvailable(
			[in] GUID* riid,
			[in] IUnknown* pUnk);
	"

	<virtual stdcall: hresult 11 GUID* IUnknown*>
	^self invalidCall: _failureCode!

OnProgress: ulProgress ulProgressMax: ulProgressMax ulStatusCode: ulStatusCode szStatusText: szStatusText
	"Private - Invoke the OnProgress() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnProgress(
			[in] unsigned long ulProgress,
			[in] unsigned long ulProgressMax,
			[in] unsigned long ulStatusCode,
			[in] LPWSTR szStatusText);
	"

	<virtual stdcall: hresult 7 dword dword dword lpwstr>
	^self invalidCall: _failureCode
!

OnStartBinding: dwReserved pib: pib
	"Private - Invoke the OnStartBinding() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnStartBinding(
			[in] unsigned long dwReserved,
			[in] IBinding* pib);
	"

	<virtual stdcall: hresult 4 dword IBinding*>
	^self invalidCall: _failureCode
!

OnStopBinding: hresult szError: szError
	"Private - Invoke the OnStopBinding() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnStopBinding(
			[in] HRESULT hresult,
			[in] LPWSTR szError);
	"

	<virtual stdcall: hresult 8 hresult lpwstr>
	^self invalidCall: _failureCode! !
!IBindStatusCallback categoriesForMethods!
GetBindInfo:pbindinfo:!COM Interfaces-IBindStatusCallback!private! !
GetPriority:!**auto generated**!COM Interfaces-IBindStatusCallback!private! !
OnDataAvailable:dwSize:pFormatetc:pStgmed:!COM Interfaces-IBindStatusCallback!private! !
OnLowResource:!**auto generated**!COM Interfaces-IBindStatusCallback!private! !
OnObjectAvailable:pUnk:!**auto generated**!COM Interfaces-IBindStatusCallback!private! !
OnProgress:ulProgressMax:ulStatusCode:szStatusText:!**auto generated**!COM Interfaces-IBindStatusCallback!private! !
OnStartBinding:pib:!**auto generated**!COM Interfaces-IBindStatusCallback!private! !
OnStopBinding:szError:!**auto generated**!COM Interfaces-IBindStatusCallback!private! !
!

!IBindStatusCallback class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IBindStatusCallback'
		IBindStatusCallback defineTemplate
	"

	self
		defineFunction: #OnStartBinding:pib:
			argumentTypes: 'dword IBinding*';
		defineFunction: #GetPriority:
			argumentTypes: 'sdword*';
		defineFunction: #OnLowResource:
			argumentTypes: 'dword';
		defineFunction: #OnProgress:ulProgressMax:ulStatusCode:szStatusText:
			argumentTypes: 'dword dword dword lpwstr';
		defineFunction: #OnStopBinding:szError:
			argumentTypes: 'hresult lpwstr';
		defineFunction: #GetBindInfo:pbindinfo:
			argumentTypes: 'dword* BINDINFO*';
		defineFunction: #OnDataAvailable:dwSize:pFormatetc:pStgmed:
			argumentTypes: 'dword dword FORMATETC* STGMEDIUM*';
		defineFunction: #OnObjectAvailable:pUnk:
			argumentTypes: 'GUID* IUnknown*'
! !
!IBindStatusCallback class categoriesForMethods!
defineFunctions!initializing!public! !
!

