"Filed out from Dolphin Smalltalk X6"!

IAdviseSink subclass: #IAdviseSink2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAdviseSink2 guid: (IID fromString: '{3D3F4F89-8502-4D89-BFD6-024365E274FC}')!
IAdviseSink2 comment: ''!
!IAdviseSink2 categoriesForClass!No category! !
!IAdviseSink2 methodsFor!

OnLinkSrcChange: OnLinkSrcChange 
	"Callout for the IAdviseSink2::OnLinkSrcChange() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in IAdviseSink2>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: void 9 IMoniker* >
	^self invalidCall! !
!IAdviseSink2 categoriesFor: #OnLinkSrcChange:!COM Interfaces-IAdviseSink2!public! !

!IAdviseSink2 class methodsFor!

defineFunctions
	"Declare the virtual functions supported by the receiver.

		IAdviseSink2 compileFunctions
	"

	self
		defineFunction: #OnLinkSrcChange: returnType: 'void' argumentTypes: 'IMoniker*'! !
!IAdviseSink2 class categoriesFor: #defineFunctions!initializing!public! !

