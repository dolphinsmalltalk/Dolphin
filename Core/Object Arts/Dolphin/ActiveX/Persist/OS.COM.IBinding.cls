"Filed out from Dolphin Smalltalk"!

IUnknown subclass: #IBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IBinding guid: (IID fromString: '{79eac9c0-baf9-11ce-8c82-00aa004ba90b}')!
IBinding comment: '<IBinding> is a wrapper class for the COM interface ''OCIDL.IBinding'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IBinding categoriesForClass!COM-Interfaces!Win32-Interfaces! !
!IBinding methodsFor!

Abort
	"Invoke the Abort() method of the COM object.

		HRESULT __stdcall Abort();"

	<virtual stdcall: hresult 4>
	^self invalidCall: _failureCode!

getBindResult
	"Invoke the GetBindResult() method of the COM object."

	| outputs |
	outputs := {GUID new.
				DWORD new.
				StructurePointer newNull: COMTaskMemory elementClass: Utf16String}.
	self
		GetBindResult: (outputs basicAt: 1)
		pdwResult: (outputs basicAt: 2)
		pszResult: (outputs basicAt: 3)
		dwReserved: 0.
	^outputs collect: [:each | each asObject]!

GetBindResult: pclsidProtocol pdwResult: pdwResult pszResult: pszResult dwReserved: dwReserved
	"Private - Invoke the GetBindResult() method of the COM object.

		HRESULT __stdcall GetBindResult(
			[out]GUID* pclsidProtocol,
			[out]DWORD* pdwResult,
			[out]LPWSTR* pszResult,
			[in]DWORD dwReserved);"

	<virtual stdcall: hresult 9 guid* dword* lpwstr* dword>
	^self invalidCall: _failureCode!

getPriority
	"Answer the <SDWORD> result of invoking the GetPriority() method of the COM object."

	| answer |
	answer := SDWORD new.
	self GetPriority: answer.
	^answer asObject!

GetPriority: pnPriority
	"Private - Invoke the GetPriority() method of the COM object.

		HRESULT __stdcall GetPriority(
			[out]long* pnPriority);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall: _failureCode!

Resume
	"Invoke the Resume() method of the COM object.

		HRESULT __stdcall Resume();"

	<virtual stdcall: hresult 6>
	^self invalidCall: _failureCode!

SetPriority: nPriority
	"Invoke the SetPriority() method of the COM object.

		HRESULT __stdcall SetPriority(
			[in]long nPriority);"

	<virtual stdcall: hresult 7 sdword>
	^self invalidCall: _failureCode!

Suspend
	"Invoke the Suspend() method of the COM object.

		HRESULT __stdcall Suspend();"

	<virtual stdcall: hresult 5>
	^self invalidCall: _failureCode! !
!IBinding categoriesForMethods!
Abort!**auto generated**!COM Interfaces-IBinding!public! !
getBindResult!methods!public! !
GetBindResult:pdwResult:pszResult:dwReserved:!**auto generated**!COM Interfaces-IBinding!private! !
getPriority!**auto generated**!methods!public! !
GetPriority:!**auto generated**!COM Interfaces-IBinding!private! !
Resume!**auto generated**!COM Interfaces-IBinding!public! !
SetPriority:!**auto generated**!COM Interfaces-IBinding!public! !
Suspend!**auto generated**!COM Interfaces-IBinding!public! !
!

!IBinding class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IBinding'
		IBinding defineTemplate
	"

	self
		defineFunction: #Abort;
		defineFunction: #Suspend;
		defineFunction: #Resume;
		defineFunction: #SetPriority:
			argumentTypes: 'sdword';
		defineFunction: #GetPriority:
			argumentTypes: 'sdword*';
		defineFunction: #GetBindResult:pdwResult:pszResult:dwReserved:
			argumentTypes: 'GUID* dword* lpwstr* dword'
! !
!IBinding class categoriesForMethods!
defineFunctions!initializing!public! !
!

