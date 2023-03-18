"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'OS.COM.IBindCtx'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IBindCtx guid: (OS.COM.IID fromString: '{0000000e-0000-0000-c000-000000000046}')!
OS.COM.IBindCtx comment: '<IBindCtx> is a wrapper class for the custom interface ''OBJIDL.IBindCtx'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

No function table has been generated for IBindCtx because this interface is implemented by the system and it is not expected that there will be any reason to implement it in Dolphin.'!
!OS.COM.IBindCtx categoriesForClass!OBJIDL-Interfaces! !
!OS.COM.IBindCtx methodsFor!

enumObjectParam
	"Answer the <IEnumString> result of invoking the EnumObjectParam() method of the COM object."

	| answer |
	answer := IEnumString newPointer.
	self EnumObjectParam: answer.
	^answer asObject!

EnumObjectParam: ppenum
	"Private - Invoke the EnumObjectParam() method of the COM object.

		HRESULT __stdcall EnumObjectParam(
			[out]IEnumString** ppenum);"

	<virtual stdcall: hresult 12 IEnumString**>
	^self invalidCall: _failureCode!

getBindOptions
	"Answer the <BIND_OPTS3> result of invoking the COM Object's GetBindOptions() method."

	| answer |
	answer := BIND_OPTS3 new.
	self GetBindOptions: answer.
	^answer!

GetBindOptions: pbindopts
	"Private - Invoke the GetBindOptions() method of the COM object.

		HRESULT __stdcall GetBindOptions(
			[in, out]BIND_OPTS2* pbindopts);"

	<virtual stdcall: hresult 8 BIND_OPTS2*>
	^self invalidCall: _failureCode!

getObjectParam: pszKey
	"Answer the <IUnknown> result of invoking the GetObjectParam() method of the COM object."

	| answer |
	answer := IUnknown newPointer.
	self GetObjectParam: pszKey asUtf16String ppunk: answer.
	^answer asObject!

GetObjectParam: pszKey ppunk: ppunk
	"Private - Invoke the GetObjectParam() method of the COM object.

		HRESULT __stdcall GetObjectParam(
			[in]LPWSTR pszKey,
			[out]IUnknown** ppunk);"

	<virtual stdcall: hresult 11 lpwstr IUnknown**>
	^self invalidCall: _failureCode!

getRunningObjectTable
	"Answer the <IRunningObjectTable> result of invoking the GetRunningObjectTable() method of the COM object."

	| answer |
	answer := IRunningObjectTable newPointer.
	self GetRunningObjectTable: answer.
	^answer asObject!

GetRunningObjectTable: pprot
	"Private - Invoke the GetRunningObjectTable() method of the COM object.

		HRESULT __stdcall GetRunningObjectTable(
			[out]IRunningObjectTable** pprot);"

	<virtual stdcall: hresult 9 IRunningObjectTable**>
	^self invalidCall: _failureCode!

RegisterObjectBound: pUnk
	"Invoke the RegisterObjectBound() method of the COM object.

		HRESULT __stdcall RegisterObjectBound(
			[in]IUnknown* pUnk);"

	<virtual stdcall: hresult 4 IUnknown*>
	^self invalidCall: _failureCode!

RegisterObjectParam: pszKey pUnk: pUnk
	"Invoke the RegisterObjectParam() method of the COM object.

		HRESULT __stdcall RegisterObjectParam(
			[in]LPWSTR pszKey,
			[in]IUnknown* pUnk);"

	<virtual stdcall: hresult 10 lpwstr IUnknown*>
	^self invalidCall: _failureCode!

ReleaseBoundObjects
	"Invoke the ReleaseBoundObjects() method of the COM object.

		HRESULT __stdcall ReleaseBoundObjects();"

	<virtual stdcall: hresult 6>
	^self invalidCall: _failureCode!

RevokeObjectBound: pUnk
	"Invoke the RevokeObjectBound() method of the COM object.

		HRESULT __stdcall RevokeObjectBound(
			[in]IUnknown* pUnk);"

	<virtual stdcall: hresult 5 IUnknown*>
	^self invalidCall: _failureCode!

RevokeObjectParam: pszKey
	"Invoke the RevokeObjectParam() method of the COM object.

		HRESULT __stdcall RevokeObjectParam(
			[in]LPWSTR pszKey);"

	<virtual stdcall: hresult 13 lpwstr>
	^self invalidCall: _failureCode!

SetBindOptions: pbindopts
	"Invoke the SetBindOptions() method of the COM object.

		HRESULT __stdcall SetBindOptions(
			[in]BIND_OPTS2* pbindopts);"

	<virtual stdcall: hresult 7 BIND_OPTS2*>
	^self invalidCall: _failureCode! !
!OS.COM.IBindCtx categoriesForMethods!
enumObjectParam!**auto generated**!methods!public! !
EnumObjectParam:!**auto generated**!COM Interfaces-IBindCtx!private! !
getBindOptions!accessing!public! !
GetBindOptions:!**auto generated**!COM Interfaces-IBindCtx!private! !
getObjectParam:!**auto generated**!methods!public! !
GetObjectParam:ppunk:!**auto generated**!COM Interfaces-IBindCtx!private! !
getRunningObjectTable!**auto generated**!methods!public! !
GetRunningObjectTable:!**auto generated**!COM Interfaces-IBindCtx!private! !
RegisterObjectBound:!**auto generated**!COM Interfaces-IBindCtx!public! !
RegisterObjectParam:pUnk:!**auto generated**!COM Interfaces-IBindCtx!public! !
ReleaseBoundObjects!**auto generated**!COM Interfaces-IBindCtx!public! !
RevokeObjectBound:!**auto generated**!COM Interfaces-IBindCtx!public! !
RevokeObjectParam:!**auto generated**!COM Interfaces-IBindCtx!public! !
SetBindOptions:!**auto generated**!COM Interfaces-IBindCtx!public! !
!

!OS.COM.IBindCtx class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'Win32.IBindCtx'
		IBindCtx defineTemplate"

	self
		defineFunction: #RegisterObjectBound:
			argumentTypes: 'IUnknown*';
		defineFunction: #RevokeObjectBound:
			argumentTypes: 'IUnknown*';
		defineFunction: #ReleaseBoundObjects;
		defineFunction: #SetBindOptions:
			argumentTypes: 'BIND_OPTS2*';
		defineFunction: #GetBindOptions:
			argumentTypes: 'BIND_OPTS2*';
		defineFunction: #GetRunningObjectTable:
			argumentTypes: 'IRunningObjectTable**';
		defineFunction: #RegisterObjectParam:pUnk:
			argumentTypes: 'lpwstr IUnknown*';
		defineFunction: #GetObjectParam:ppunk:
			argumentTypes: 'lpwstr IUnknown**';
		defineFunction: #EnumObjectParam:
			argumentTypes: 'IEnumString**';
		defineFunction: #RevokeObjectParam:
			argumentTypes: 'lpwstr'
!

new
	"Answer a new Bind Context (implemented by system)"

	| answer |
	answer := self newPointer.
	Ole32 createBindCtx: 0 ppbc: answer.
	^answer! !
!OS.COM.IBindCtx class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
new!instance creation!public! !
!

