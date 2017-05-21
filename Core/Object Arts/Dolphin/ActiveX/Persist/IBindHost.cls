"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IBindHost
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IBindHost guid: (IID fromString: '{FC4801A1-2BA9-11CF-A229-00AA003D7352}')!
IBindHost comment: '<IBindHost> is a wrapper class for the COM interface ''OCIDL.IBindHost'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IBindHost categoriesForClass!COM-Interfaces! !
!IBindHost methodsFor!

createMoniker: szName pbc: pbc dwReserved: dwReserved 
	"Answer the <IMoniker> result of invoking the COM Object's CreateMoniker() method."

	| answer |
	answer := IMoniker newPointer.
	self
		CreateMoniker: szName asUnicodeString
		pbc: pbc
		ppmk: answer
		dwReserved: dwReserved.
	^answer asObject
!

CreateMoniker: szName pbc: pbc ppmk: ppmk dwReserved: dwReserved
	"Private - Invoke the CreateMoniker() method of the COM object wrapped by the receiver.

		HRESULT __stdcall CreateMoniker(
			[in] LPWSTR szName,
			[in] IBindCtx* pbc,
			[out] IMoniker** ppmk,
			[in] unsigned long dwReserved);
	"

	<virtual stdcall: hresult 4 lpwstr IBindCtx* IMoniker** dword>
	^self invalidCall
!

monikerBindToObject: pmk pbc: pbc pBSC: pBSC riid: riid 
	"Answer the <IUnknown> result of invoking the COM Object's MonikerBindToObject() method."

	| answer |
	answer := (COMInterface classForIID: riid ifNone: [IUnknown]) newPointer.
	self
		MonikerBindToObject: pmk
		pbc: pbc
		pBSC: pBSC
		riid: riid
		ppvObj: answer.
	^answer
!

MonikerBindToObject: pmk pbc: pbc pBSC: pBSC riid: riid ppvObj: ppvObj
	"Private - Invoke the MonikerBindToObject() method of the COM object wrapped by the receiver.

		HRESULT __stdcall MonikerBindToObject(
			[in] IMoniker* pmk,
			[in] IBindCtx* pbc,
			[in] IBindStatusCallback* pBSC,
			[in] GUID* riid,
			[out] IUnknown** ppvObj);
	"

	<virtual stdcall: hresult 6 IMoniker* IBindCtx* IBindStatusCallback* GUID* IUnknown**>
	^self invalidCall
!

monikerBindToStorage: pmk pbc: pbc pBSC: pBSC riid: riid 
	"Answer the <IUnknown> result of invoking the COM Object's MonikerBindToStorage() method.
	If the IID specifies a known COMInterface type, then the answer will be of the correct class."

	| answer |
	answer := (COMInterface classForIID: riid ifNone: [IUnknown]) newPointer.
	self
		MonikerBindToStorage: pmk
		pbc: pbc
		pBSC: pBSC
		riid: riid
		ppvObj: answer.
	^answer
!

MonikerBindToStorage: pmk pbc: pbc pBSC: pBSC riid: riid ppvObj: ppvObj
	"Private - Invoke the MonikerBindToStorage() method of the COM object wrapped by the receiver.

		HRESULT __stdcall MonikerBindToStorage(
			[in] IMoniker* pmk,
			[in] IBindCtx* pbc,
			[in] IBindStatusCallback* pBSC,
			[in] GUID* riid,
			[out] IUnknown** ppvObj);
	"

	<virtual stdcall: hresult 5 IMoniker* IBindCtx* IBindStatusCallback* GUID* IUnknown**>
	^self invalidCall
! !
!IBindHost categoriesFor: #createMoniker:pbc:dwReserved:!**auto generated**!methods!public! !
!IBindHost categoriesFor: #CreateMoniker:pbc:ppmk:dwReserved:!**auto generated**!COM Interfaces-IBindHost!private! !
!IBindHost categoriesFor: #monikerBindToObject:pbc:pBSC:riid:!methods!public! !
!IBindHost categoriesFor: #MonikerBindToObject:pbc:pBSC:riid:ppvObj:!COM Interfaces-IBindHost!private! !
!IBindHost categoriesFor: #monikerBindToStorage:pbc:pBSC:riid:!methods!public! !
!IBindHost categoriesFor: #MonikerBindToStorage:pbc:pBSC:riid:ppvObj:!COM Interfaces-IBindHost!private! !

!IBindHost class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IBindHost'
		IBindHost defineTemplate
	"

	self
		defineFunction: #CreateMoniker:pbc:ppmk:dwReserved:
			argumentTypes: 'lpwstr IBindCtx* IMoniker** dword';
		defineFunction: #MonikerBindToStorage:pbc:pBSC:riid:ppvObj:
			argumentTypes: 'IMoniker* IBindCtx* IBindStatusCallback* GUID* IUnknown**';
		defineFunction: #MonikerBindToObject:pbc:pBSC:riid:ppvObj:
			argumentTypes: 'IMoniker* IBindCtx* IBindStatusCallback* GUID* IUnknown**'
! !
!IBindHost class categoriesFor: #defineFunctions!initializing!public! !

