"Filed out from Dolphin Smalltalk"!

IAdviseSink subclass: #IAdviseSink2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAdviseSink2 guid: (IID fromString: '{3d3f4f89-8502-4d89-bfd6-024365e274fc}')!
IAdviseSink2 comment: ''!
!IAdviseSink2 categoriesForClass!OBJIDL-Interfaces! !
!IAdviseSink2 methodsFor!

OnLinkSrcChange: onLinkSrcChange
	"Callout for the IAdviseSink2::OnLinkSrcChange() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in IAdviseSink2>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: void 9 IMoniker*>
	^self invalidCall: _failureCode! !
!IAdviseSink2 categoriesForMethods!
OnLinkSrcChange:!COM Interfaces-IAdviseSink2!public! !
!

!IAdviseSink2 class methodsFor!

defineFunctions
	"Declare the virtual functions supported by the receiver.

		IAdviseSink2 compileFunctions
	"

	self
		defineFunction: #OnLinkSrcChange: returnType: 'void' argumentTypes: 'IMoniker*'! !
!IAdviseSink2 class categoriesForMethods!
defineFunctions!initializing!public! !
!

