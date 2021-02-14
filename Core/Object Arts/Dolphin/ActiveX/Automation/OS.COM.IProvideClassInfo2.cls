"Filed out from Dolphin Smalltalk 7"!

OS.COM.IProvideClassInfo subclass: #'OS.COM.IProvideClassInfo2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IProvideClassInfo2 guid: (OS.COM.IID fromString: '{a6bc3ac0-dbaa-11ce-9de3-00aa004bb851}')!
OS.COM.IProvideClassInfo2 comment: '<IProvideClassInfo2> is a wrapper class for the COM interface ''OCIDL.IProvideClassInfo2'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

IProvideClassInfo2 extends IProvideClassInfo by adding a method to enquire the <GUID>s for various aspects of the COM objects coclass. At present the only aspect defined is the IID of the default source (event) interface.'!
!OS.COM.IProvideClassInfo2 categoriesForClass!COM-Interfaces! !
!OS.COM.IProvideClassInfo2 methodsFor!

getGUID: dwGuidKind 
	"Answer the <GUID> result of invoking the COM Object's GetGUID() method."

	| answer |
	answer := GUID new.
	self
		GetGUID: dwGuidKind
		pGUID: answer.
	^answer asObject
!

GetGUID: dwGuidKind pGUID: pGUID
	"Private - Invoke the GetGUID() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetGUID(
			[in] unsigned long dwGuidKind,
			[out] GUID* pGUID);
	"

	<virtual stdcall: hresult 5 dword guid*>
	^self invalidCall: _failureCode! !
!OS.COM.IProvideClassInfo2 categoriesFor: #getGUID:!**auto generated**!methods!public! !
!OS.COM.IProvideClassInfo2 categoriesFor: #GetGUID:pGUID:!**auto generated**!COM Interfaces-IProvideClassInfo2!private! !

OS.COM.IProvideClassInfo2 methodProtocol: #IProvideClassInfo2 attributes: #(#readOnly) selectors: #(#GetClassInfo: #GetGUID:pGUID:)!

!OS.COM.IProvideClassInfo2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IProvideClassInfo2'
		IProvideClassInfo2 defineTemplate
	"

	self
		defineFunction: #GetGUID:pGUID:
			argumentTypes: 'dword GUID*'
! !
!OS.COM.IProvideClassInfo2 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

