"Filed out from Dolphin Smalltalk"!

OS.COM.IAdviseSink subclass: #'OS.COM.IAdviseSinkEx'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IAdviseSinkEx guid: (OS.COM.IID fromString: '{3af24290-0c96-11ce-a0cf-00aa00600ab8}')!
OS.COM.IAdviseSinkEx comment: '<IAdviseSinkEx> is a wrapper class for the COM interface ''OCIDL.IAdviseSinkEx'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!OS.COM.IAdviseSinkEx categoriesForClass!OBJIDL-Interfaces! !
!OS.COM.IAdviseSinkEx methodsFor!

OnViewStatusChange: dwViewStatus
	"Invoke the OnViewStatusChange() method of the COM object.

		HRESULT __stdcall OnViewStatusChange(
			[in]DWORD dwViewStatus);"

	<virtual stdcall: hresult 9 uint32>
	^self invalidCall: _failureCode! !
!OS.COM.IAdviseSinkEx categoriesForMethods!
OnViewStatusChange:!**auto generated**!COM Interfaces-IAdviseSinkEx!public! !
!

!OS.COM.IAdviseSinkEx class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IAdviseSinkEx'
		IAdviseSinkEx defineTemplate
	"

	self defineFunction: #OnViewStatusChange: argumentTypes: 'dword'! !
!OS.COM.IAdviseSinkEx class categoriesForMethods!
defineFunctions!initializing!public! !
!

