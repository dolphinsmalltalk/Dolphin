"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IProvideClassInfo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IProvideClassInfo guid: (IID fromString: '{b196b283-bab4-101a-b69c-00aa00341d07}')!
IProvideClassInfo comment: '<IProvideClassInfo> is a wrapper class for the COM interface ''OCIDL.IProvideClassInfo'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

IProvideClassInfo contains a single method, #getClassInfo, to enquire the type information (ITypeInfo) for the coclass of the COM object.'!
!IProvideClassInfo categoriesForClass!COM-Interfaces! !
!IProvideClassInfo methodsFor!

getClassInfo
	"Answer the <ITypeInfo> result of invoking the COM Object's GetClassInfo() method."

	| ppTI |
	ppTI := ITypeInfo newPointer.
	self GetClassInfo: ppTI.
	^ppTI
!

GetClassInfo: ppTI
	"Private - Invoke the GetClassInfo() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetClassInfo(
			[out] ITypeInfo** ppTI);
	"

	<virtual stdcall: hresult 4 ITypeInfo**>
	^self invalidCall: _failureCode! !
!IProvideClassInfo categoriesFor: #getClassInfo!**auto generated**!public! !
!IProvideClassInfo categoriesFor: #GetClassInfo:!COM Interfaces-OCIDL.IProvideClassInfo!private! !

IProvideClassInfo methodProtocol: #IProvideClassInfo attributes: #(#readOnly) selectors: #(#GetClassInfo:)!

!IProvideClassInfo class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IProvideClassInfo'
		IProvideClassInfo defineTemplate
	"

	self
		defineFunction: #GetClassInfo:
			argumentTypes: 'ITypeInfo**'
! !
!IProvideClassInfo class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

