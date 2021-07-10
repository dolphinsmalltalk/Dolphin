"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IBindCtx
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IBindCtx guid: (IID fromString: '{0000000E-0000-0000-C000-000000000046}')!
IBindCtx comment: '<IBindCtx> is a wrapper class for the custom interface ''OBJIDL.IBindCtx'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

No function table has been generated for IBindCtx because this interface is implemented by the system and it is not expected that there will be any reason to implement it in Dolphin.'!
!IBindCtx categoriesForClass!COM-Interfaces! !
!IBindCtx methodsFor!

bindOptions
	"Answer a BIND_OPTS2 describing the current bind options."

	| answer |
	answer := BIND_OPTS2 new.
	self GetBindOptions: answer.
	^answer!

enumObjectParam
	"Answer the <IEnumString> result of invoking the COM Object's EnumObjectParam() method."

	| answer |
	answer := IEnumString newPointer.
	self
		EnumObjectParam: answer.
	^answer asObject
!

EnumObjectParam: ppenum
	"Private - Invoke the EnumObjectParam() method of the COM object wrapped by the receiver.

		HRESULT __stdcall EnumObjectParam(
			[out] IEnumString** ppenum);
	"

	<virtual stdcall: hresult 12 IEnumString**>
	^self invalidCall
!

getBindOptions
	"Answer the <BIND_OPTS2> result of invoking the COM Object's GetBindOptions() method."

	| answer |
	answer := BIND_OPTS2 new.
	self GetBindOptions: answer.
	^answer
!

GetBindOptions: pbindopts
	"Private - Invoke the GetBindOptions() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetBindOptions(
			[in, out] BIND_OPTS2* pbindopts);
	"

	<virtual stdcall: hresult 8 BIND_OPTS2*>
	^self invalidCall
!

getObjectParam: pszKey 
	"Answer the <IUnknown> result of invoking the COM Object's GetObjectParam() method."

	| answer |
	answer := IUnknown newPointer.
	self
		GetObjectParam: pszKey asUnicodeString
		ppunk: answer.
	^answer asObject
!

GetObjectParam: pszKey ppunk: ppunk
	"Private - Invoke the GetObjectParam() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetObjectParam(
			[in] LPWSTR pszKey,
			[out] IUnknown** ppunk);
	"

	<virtual stdcall: hresult 11 lpwstr IUnknown**>
	^self invalidCall
!

getRunningObjectTable
	"Answer the <IRunningObjectTable> result of invoking the COM Object's GetRunningObjectTable() method."

	| answer |
	answer := IRunningObjectTable newPointer.
	self
		GetRunningObjectTable: answer.
	^answer asObject
!

GetRunningObjectTable: pprot
	"Private - Invoke the GetRunningObjectTable() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetRunningObjectTable(
			[out] IRunningObjectTable** pprot);
	"

	<virtual stdcall: hresult 9 IRunningObjectTable**>
	^self invalidCall
!

registerObjectBound: punk 
	"Invoke the RegisterObjectBound() method of the COM Object."

	self
		RegisterObjectBound: punk
!

RegisterObjectBound: punk
	"Private - Invoke the RegisterObjectBound() method of the COM object wrapped by the receiver.

		HRESULT __stdcall RegisterObjectBound(
			[in] IUnknown* punk);
	"

	<virtual stdcall: hresult 4 IUnknown*>
	^self invalidCall
!

registerObjectParam: pszKey punk: punk 
	"Invoke the RegisterObjectParam() method of the COM Object."

	self
		RegisterObjectParam: pszKey asUnicodeString
		punk: punk
!

RegisterObjectParam: pszKey punk: punk
	"Private - Invoke the RegisterObjectParam() method of the COM object wrapped by the receiver.

		HRESULT __stdcall RegisterObjectParam(
			[in] LPWSTR pszKey,
			[in] IUnknown* punk);
	"

	<virtual stdcall: hresult 10 lpwstr IUnknown*>
	^self invalidCall
!

releaseBoundObjects  
	"Invoke the ReleaseBoundObjects() method of the COM Object."

	self ReleaseBoundObjects
!

ReleaseBoundObjects 
	"Private - Invoke the ReleaseBoundObjects() method of the COM object wrapped by the receiver.

		HRESULT __stdcall ReleaseBoundObjects();
	"

	<virtual stdcall: hresult 6>
	^self invalidCall
!

revokeObjectBound: punk 
	"Invoke the RevokeObjectBound() method of the COM Object."

	self
		RevokeObjectBound: punk
!

RevokeObjectBound: punk
	"Private - Invoke the RevokeObjectBound() method of the COM object wrapped by the receiver.

		HRESULT __stdcall RevokeObjectBound(
			[in] IUnknown* punk);
	"

	<virtual stdcall: hresult 5 IUnknown*>
	^self invalidCall
!

revokeObjectParam: pszKey 
	"Invoke the RevokeObjectParam() method of the COM Object."

	self
		RevokeObjectParam: pszKey asUnicodeString
!

RevokeObjectParam: pszKey
	"Private - Invoke the RevokeObjectParam() method of the COM object wrapped by the receiver.

		HRESULT __stdcall RevokeObjectParam(
			[in] LPWSTR pszKey);
	"

	<virtual stdcall: hresult 13 lpwstr>
	^self invalidCall
!

setBindOptions: pbindopts 
	"Invoke the SetBindOptions() method of the COM Object."

	self
		setBindOptions: pbindopts
!

SetBindOptions: pbindopts
	"Private - Invoke the SetBindOptions() method of the COM object wrapped by the receiver.

		HRESULT __stdcall SetBindOptions(
			[in] BIND_OPTS2* pbindopts);
	"

	<virtual stdcall: hresult 7 BIND_OPTS2*>
	^self invalidCall
! !
!IBindCtx categoriesFor: #bindOptions!accessing!public! !
!IBindCtx categoriesFor: #enumObjectParam!**auto generated**!public! !
!IBindCtx categoriesFor: #EnumObjectParam:!**auto generated**!private! !
!IBindCtx categoriesFor: #getBindOptions!accessing!public! !
!IBindCtx categoriesFor: #GetBindOptions:!**auto generated**!private! !
!IBindCtx categoriesFor: #getObjectParam:!**auto generated**!public! !
!IBindCtx categoriesFor: #GetObjectParam:ppunk:!**auto generated**!private! !
!IBindCtx categoriesFor: #getRunningObjectTable!**auto generated**!public! !
!IBindCtx categoriesFor: #GetRunningObjectTable:!**auto generated**!private! !
!IBindCtx categoriesFor: #registerObjectBound:!**auto generated**!public! !
!IBindCtx categoriesFor: #RegisterObjectBound:!**auto generated**!private! !
!IBindCtx categoriesFor: #registerObjectParam:punk:!**auto generated**!public! !
!IBindCtx categoriesFor: #RegisterObjectParam:punk:!**auto generated**!private! !
!IBindCtx categoriesFor: #releaseBoundObjects!**auto generated**!public! !
!IBindCtx categoriesFor: #ReleaseBoundObjects!**auto generated**!private! !
!IBindCtx categoriesFor: #revokeObjectBound:!**auto generated**!public! !
!IBindCtx categoriesFor: #RevokeObjectBound:!**auto generated**!private! !
!IBindCtx categoriesFor: #revokeObjectParam:!**auto generated**!public! !
!IBindCtx categoriesFor: #RevokeObjectParam:!**auto generated**!private! !
!IBindCtx categoriesFor: #setBindOptions:!**auto generated**!public! !
!IBindCtx categoriesFor: #SetBindOptions:!**auto generated**!private! !

!IBindCtx class methodsFor!

new
	"Answer a new Bind Context (implemented by system)"

	| answer |
	answer := self newPointer.
	Ole32 createBindCtx: 0 ppbc: answer.
	^answer! !
!IBindCtx class categoriesFor: #new!instance creation!public! !

