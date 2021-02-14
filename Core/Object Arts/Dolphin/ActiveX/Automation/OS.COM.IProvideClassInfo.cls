"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'OS.COM.IProvideClassInfo'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IProvideClassInfo guid: (OS.COM.IID fromString: '{b196b283-bab4-101a-b69c-00aa00341d07}')!
OS.COM.IProvideClassInfo comment: '<IProvideClassInfo> is a wrapper class for the COM interface ''OCIDL.IProvideClassInfo'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

IProvideClassInfo contains a single method, #getClassInfo, to enquire the type information (ITypeInfo) for the coclass of the COM object.'!
!OS.COM.IProvideClassInfo categoriesForClass!COM-Interfaces! !
!OS.COM.IProvideClassInfo methodsFor!

getClassInfo
	"Answer the <ITypeInfo> result of invoking the COM Object's GetClassInfo() method."

	| ppTI |
	ppTI := ITypeInfo newPointer.
	self GetClassInfo: ppTI.
	^ppTI!

GetClassInfo: ppTI
	"Private - Invoke the GetClassInfo() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetClassInfo(
			[out] ITypeInfo** ppTI);
	"

	<virtual stdcall: hresult 4 ITypeInfo**>
	^self invalidCall: _failureCode! !
!OS.COM.IProvideClassInfo categoriesFor: #getClassInfo!**auto generated**!public! !
!OS.COM.IProvideClassInfo categoriesFor: #GetClassInfo:!COM Interfaces-OCIDL.IProvideClassInfo!private! !

OS.COM.IProvideClassInfo methodProtocol: #IProvideClassInfo attributes: #(#readOnly) selectors: #(#GetClassInfo:)!

!OS.COM.IProvideClassInfo class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IProvideClassInfo'
		IProvideClassInfo defineTemplate
	"

	self
		defineFunction: #GetClassInfo:
			argumentTypes: 'ITypeInfo**'
! !
!OS.COM.IProvideClassInfo class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

