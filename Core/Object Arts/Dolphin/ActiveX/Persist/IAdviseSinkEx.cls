"Filed out from Dolphin Smalltalk 7"!

IAdviseSink subclass: #IAdviseSinkEx
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAdviseSinkEx guid: (IID fromString: '{3AF24290-0C96-11CE-A0CF-00AA00600AB8}')!
IAdviseSinkEx comment: '<IAdviseSinkEx> is a wrapper class for the COM interface ''OCIDL.IAdviseSinkEx'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAdviseSinkEx categoriesForClass!COM-Interfaces! !
!IAdviseSinkEx methodsFor!

onViewStatusChange: dwViewStatus 
	"Invoke the OnViewStatusChange() method of the COM Object."

	self
		OnViewStatusChange: dwViewStatus
!

OnViewStatusChange: dwViewStatus
	"Private - Invoke the OnViewStatusChange() method of the COM object wrapped by the receiver.

		void __stdcall OnViewStatusChange(
			[in] unsigned long dwViewStatus);
	"

	<virtual stdcall: hresult 9 dword>
	^self invalidCall
! !
!IAdviseSinkEx categoriesFor: #onViewStatusChange:!methods!public! !
!IAdviseSinkEx categoriesFor: #OnViewStatusChange:!COM Interfaces-IAdviseSinkEx!private! !

!IAdviseSinkEx class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IAdviseSinkEx'
		IAdviseSinkEx defineTemplate
	"

	self
		defineFunction: #OnViewStatusChange:
			argumentTypes: 'dword'
! !
!IAdviseSinkEx class categoriesFor: #defineFunctions!initializing!public! !

