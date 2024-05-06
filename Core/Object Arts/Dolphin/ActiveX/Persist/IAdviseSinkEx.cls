"Filed out from Dolphin Smalltalk"!

IAdviseSink subclass: #IAdviseSinkEx
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

IAdviseSinkEx guid: (IID fromString: '{3af24290-0c96-11ce-a0cf-00aa00600ab8}')!

IAdviseSinkEx comment: '<IAdviseSinkEx> is a wrapper class for the COM interface ''OCIDL.IAdviseSinkEx'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!

!IAdviseSinkEx categoriesForClass!OBJIDL-Interfaces! !

!IAdviseSinkEx methodsFor!

OnViewStatusChange: dwViewStatus
	"Invoke the OnViewStatusChange() method of the COM object.

		HRESULT __stdcall OnViewStatusChange(
			[in]DWORD dwViewStatus);"

	<virtual stdcall: hresult 9 dword>
	^self invalidCall: _failureCode! !

!IAdviseSinkEx categoriesForMethods!
OnViewStatusChange:!**auto generated**!COM Interfaces-IAdviseSinkEx!public! !
!

!IAdviseSinkEx class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IAdviseSinkEx'
		IAdviseSinkEx defineTemplate
	"

	self defineFunction: #OnViewStatusChange: argumentTypes: 'dword'! !

!IAdviseSinkEx class categoriesForMethods!
defineFunctions!initializing!public! !
!

