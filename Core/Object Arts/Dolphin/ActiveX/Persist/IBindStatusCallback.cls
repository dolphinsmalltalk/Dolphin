"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IBindStatusCallback
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IBindStatusCallback guid: (IID fromString: '{79EAC9C1-BAF9-11CE-8C82-00AA004BA90B}')!
IBindStatusCallback comment: '<IBindStatusCallback> is a wrapper class for the COM interface ''OCIDL.IBindStatusCallback'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IBindStatusCallback categoriesForClass!COM-Interfaces! !
!IBindStatusCallback methodsFor!

getBindInfo: pbindinfo
	"Invoke the GetBindInfo() method of the COM Object."

	| answer |
	answer := DWORD new.
	self
		GetBindInfo: answer
		pbindinfo: pbindinfo.
	^answer asObject
!

GetBindInfo: grfBINDF pbindinfo: pbindinfo
	"Private - Invoke the GetBindInfo() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetBindInfo(
			[out] unsigned long* grfBINDF,
			[in, out] BINDINFO* pbindinfo);
	"

	<virtual stdcall: hresult 9 dword* BINDINFO*>
	^self invalidCall
!

getPriority
	"Answer the <SDWORD> result of invoking the COM Object's GetPriority() method."

	| answer |
	answer := (SDWORD new).
	self
		GetPriority: answer.
	^answer asObject
!

GetPriority: pnPriority
	"Private - Invoke the GetPriority() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetPriority(
			[out] long* pnPriority);
	"

	<virtual stdcall: hresult 5 sdword*>
	^self invalidCall
!

onDataAvailable: grfBSCF dwSize: dwSize pFormatetc: pFormatetc pStgmed: pStgmed 
	"Invoke the OnDataAvailable() method of the COM Object."

	self
		OnDataAvailable: grfBSCF
		dwSize: dwSize
		pFormatetc: pFormatetc
		pStgmed: pStgmed
!

OnDataAvailable: grfBSCF dwSize: dwSize pFormatetc: pFormatetc pStgmed: pStgmed
	"Private - Invoke the OnDataAvailable() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnDataAvailable(
			[in] unsigned long grfBSCF,
			[in] unsigned long dwSize,
			[in] FORMATETC* pFormatetc,
			[in] STGMEDIUM* pStgmed);
	"

	<virtual stdcall: hresult 10 dword dword FORMATETC* STGMEDIUM*>
	^self invalidCall
!

onLowResource: reserved 
	"Invoke the OnLowResource() method of the COM Object."

	self
		OnLowResource: reserved
!

OnLowResource: reserved
	"Private - Invoke the OnLowResource() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnLowResource(
			[in] unsigned long reserved);
	"

	<virtual stdcall: hresult 6 dword>
	^self invalidCall
!

onObjectAvailable: riid pUnk: pUnk 
	"Invoke the OnObjectAvailable() method of the COM Object."

	self
		OnObjectAvailable: riid
		pUnk: pUnk
!

OnObjectAvailable: riid pUnk: pUnk
	"Private - Invoke the OnObjectAvailable() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnObjectAvailable(
			[in] GUID* riid,
			[in] IUnknown* pUnk);
	"

	<virtual stdcall: hresult 11 GUID* IUnknown*>
	^self invalidCall
!

onProgress: ulProgress ulProgressMax: ulProgressMax ulStatusCode: ulStatusCode szStatusText: szStatusText 
	"Invoke the OnProgress() method of the COM Object."

	self
		OnProgress: ulProgress
		ulProgressMax: ulProgressMax
		ulStatusCode: ulStatusCode
		szStatusText: szStatusText asUnicodeString
!

OnProgress: ulProgress ulProgressMax: ulProgressMax ulStatusCode: ulStatusCode szStatusText: szStatusText
	"Private - Invoke the OnProgress() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnProgress(
			[in] unsigned long ulProgress,
			[in] unsigned long ulProgressMax,
			[in] unsigned long ulStatusCode,
			[in] LPWSTR szStatusText);
	"

	<virtual stdcall: hresult 7 dword dword dword lpwstr>
	^self invalidCall
!

onStartBinding: dwReserved pib: pib 
	"Invoke the OnStartBinding() method of the COM Object."

	self
		OnStartBinding: dwReserved
		pib: pib
!

OnStartBinding: dwReserved pib: pib
	"Private - Invoke the OnStartBinding() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnStartBinding(
			[in] unsigned long dwReserved,
			[in] IBinding* pib);
	"

	<virtual stdcall: hresult 4 dword IBinding*>
	^self invalidCall
!

onStopBinding: hresult szError: szError 
	"Invoke the OnStopBinding() method of the COM Object."

	self
		OnStopBinding: hresult
		szError: szError asUnicodeString
!

OnStopBinding: hresult szError: szError
	"Private - Invoke the OnStopBinding() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnStopBinding(
			[in] HRESULT hresult,
			[in] LPWSTR szError);
	"

	<virtual stdcall: hresult 8 hresult lpwstr>
	^self invalidCall
! !
!IBindStatusCallback categoriesFor: #getBindInfo:!methods!public! !
!IBindStatusCallback categoriesFor: #GetBindInfo:pbindinfo:!COM Interfaces-IBindStatusCallback!private! !
!IBindStatusCallback categoriesFor: #getPriority!**auto generated**!methods!public! !
!IBindStatusCallback categoriesFor: #GetPriority:!**auto generated**!COM Interfaces-IBindStatusCallback!private! !
!IBindStatusCallback categoriesFor: #onDataAvailable:dwSize:pFormatetc:pStgmed:!methods!public! !
!IBindStatusCallback categoriesFor: #OnDataAvailable:dwSize:pFormatetc:pStgmed:!COM Interfaces-IBindStatusCallback!private! !
!IBindStatusCallback categoriesFor: #onLowResource:!**auto generated**!methods!public! !
!IBindStatusCallback categoriesFor: #OnLowResource:!**auto generated**!COM Interfaces-IBindStatusCallback!private! !
!IBindStatusCallback categoriesFor: #onObjectAvailable:pUnk:!**auto generated**!methods!public! !
!IBindStatusCallback categoriesFor: #OnObjectAvailable:pUnk:!**auto generated**!COM Interfaces-IBindStatusCallback!private! !
!IBindStatusCallback categoriesFor: #onProgress:ulProgressMax:ulStatusCode:szStatusText:!**auto generated**!methods!public! !
!IBindStatusCallback categoriesFor: #OnProgress:ulProgressMax:ulStatusCode:szStatusText:!**auto generated**!COM Interfaces-IBindStatusCallback!private! !
!IBindStatusCallback categoriesFor: #onStartBinding:pib:!**auto generated**!methods!public! !
!IBindStatusCallback categoriesFor: #OnStartBinding:pib:!**auto generated**!COM Interfaces-IBindStatusCallback!private! !
!IBindStatusCallback categoriesFor: #onStopBinding:szError:!**auto generated**!methods!public! !
!IBindStatusCallback categoriesFor: #OnStopBinding:szError:!**auto generated**!COM Interfaces-IBindStatusCallback!private! !

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
!IBindStatusCallback class categoriesFor: #defineFunctions!initializing!public! !

