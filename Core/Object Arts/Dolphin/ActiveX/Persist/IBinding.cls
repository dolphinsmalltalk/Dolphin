"Filed out from Dolphin Smalltalk X6"!

IUnknown subclass: #IBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IBinding guid: (IID fromString: '{79EAC9C0-BAF9-11CE-8C82-00AA004BA90B}')!
IBinding comment: '<IBinding> is a wrapper class for the COM interface ''OCIDL.IBinding'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IBinding categoriesForClass!COM-Interfaces! !
!IBinding methodsFor!

abort  
	"Invoke the Abort() method of the COM Object."

	self Abort
!

Abort 
	"Private - Invoke the Abort() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Abort();
	"

	<virtual stdcall: hresult 4>
	^self invalidCall
!

GetBindResult: dwReserved 
	"Invoke the GetBindResult() method of the COM Object."

	| answer |
	answer := (Array new: 3)
				basicAt: 1 put: GUID new;
				basicAt: 2 put: (DWORD new);
				basicAt: 3 put: (StructurePointer newNull: COMTaskMemory elementClass: UnicodeString);
				yourself.
	self
		GetBindResult: (answer basicAt: 1)
		pdwResult: (answer basicAt: 2)
		pszResult: (answer basicAt: 3)
		dwReserved: dwReserved.
	^answer collect: [:e | e asObject]
!

GetBindResult: pclsidProtocol pdwResult: pdwResult pszResult: pszResult dwReserved: dwReserved
	"Private - Invoke the GetBindResult() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetBindResult(
			[out] GUID* pclsidProtocol,
			[out] unsigned long* pdwResult,
			[out] LPWSTR* pszResult,
			[in] unsigned long dwReserved);
	"

	<virtual stdcall: hresult 9 GUID* dword* lpwstr* dword>
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

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

resume  
	"Invoke the Resume() method of the COM Object."

	self Resume
!

Resume 
	"Private - Invoke the Resume() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Resume();
	"

	<virtual stdcall: hresult 6>
	^self invalidCall
!

setPriority: nPriority 
	"Invoke the SetPriority() method of the COM Object."

	self
		SetPriority: nPriority
!

SetPriority: nPriority
	"Private - Invoke the SetPriority() method of the COM object wrapped by the receiver.

		HRESULT __stdcall SetPriority(
			[in] long nPriority);
	"

	<virtual stdcall: hresult 7 sdword>
	^self invalidCall
!

suspend  
	"Invoke the Suspend() method of the COM Object."

	self Suspend
!

Suspend 
	"Private - Invoke the Suspend() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Suspend();
	"

	<virtual stdcall: hresult 5>
	^self invalidCall
! !
!IBinding categoriesFor: #abort!**auto generated**!methods!public! !
!IBinding categoriesFor: #Abort!**auto generated**!COM Interfaces-IBinding!private! !
!IBinding categoriesFor: #GetBindResult:!methods!public! !
!IBinding categoriesFor: #GetBindResult:pdwResult:pszResult:dwReserved:!COM Interfaces-IBinding!private! !
!IBinding categoriesFor: #getPriority!**auto generated**!methods!public! !
!IBinding categoriesFor: #GetPriority:!**auto generated**!COM Interfaces-IBinding!private! !
!IBinding categoriesFor: #resume!**auto generated**!methods!public! !
!IBinding categoriesFor: #Resume!**auto generated**!COM Interfaces-IBinding!private! !
!IBinding categoriesFor: #setPriority:!**auto generated**!methods!public! !
!IBinding categoriesFor: #SetPriority:!**auto generated**!COM Interfaces-IBinding!private! !
!IBinding categoriesFor: #suspend!**auto generated**!methods!public! !
!IBinding categoriesFor: #Suspend!**auto generated**!COM Interfaces-IBinding!private! !

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
!IBinding class categoriesFor: #defineFunctions!initializing!public! !

