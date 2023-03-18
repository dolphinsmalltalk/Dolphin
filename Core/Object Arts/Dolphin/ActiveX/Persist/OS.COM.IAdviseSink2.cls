"Filed out from Dolphin Smalltalk"!

OS.COM.IAdviseSink
	subclass: #'OS.COM.IAdviseSink2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IAdviseSink2 guid: (OS.COM.IID fromString: '{3d3f4f89-8502-4d89-bfd6-024365e274fc}')!
OS.COM.IAdviseSink2 comment: ''!
!OS.COM.IAdviseSink2 categoriesForClass!OBJIDL-Interfaces! !
!OS.COM.IAdviseSink2 methodsFor!

OnLinkSrcChange: onLinkSrcChange
	"Callout for the IAdviseSink2::OnLinkSrcChange() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in IAdviseSink2>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: void 9 IMoniker*>
	^self invalidCall: _failureCode! !
!OS.COM.IAdviseSink2 categoriesForMethods!
OnLinkSrcChange:!COM Interfaces-IAdviseSink2!public! !
!

!OS.COM.IAdviseSink2 class methodsFor!

defineFunctions
	"Declare the virtual functions supported by the receiver.

		IAdviseSink2 compileFunctions
	"

	self
		defineFunction: #OnLinkSrcChange: returnType: 'void' argumentTypes: 'IMoniker*'! !
!OS.COM.IAdviseSink2 class categoriesForMethods!
defineFunctions!initializing!public! !
!

