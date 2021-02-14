"Filed out from Dolphin Smalltalk 7"!

OS.COM.IPersistPropertyBag subclass: #'OS.COM.IPersistPropertyBag2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IPersistPropertyBag2 guid: (OS.COM.IID fromString: '{22f55881-280b-11d0-a8a9-00a0c90c2004}')!
OS.COM.IPersistPropertyBag2 comment: '`OS.COM.IPersistPropertyBag2` is a wrapper class for the COM interface ''OCIDL.IPersistPropertyBag2'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!OS.COM.IPersistPropertyBag2 categoriesForClass!COM-Interfaces! !
!OS.COM.IPersistPropertyBag2 methodsFor!

IsDirty
	"Private - Invoke the IsDirty() method of the COM object wrapped by the receiver.

		HRESULT __stdcall IsDirty();
	"

	<virtual stdcall: hresult 8>
	^self invalidCall: _failureCode! !
!OS.COM.IPersistPropertyBag2 categoriesFor: #IsDirty!**auto generated**!COM Interfaces-IPersistPropertyBag2!private! !

OS.COM.IPersistPropertyBag2 methodProtocol: #IPersistPropertyBag2 attributes: #(#readOnly) selectors: #(#InitNew #IsDirty #Save:fClearDirty:fSaveAllProperties:)!

!OS.COM.IPersistPropertyBag2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IPersistPropertyBag2'
		IPersistPropertyBag2 defineTemplate

	Implementation Note: The superclass function table is slightly different, in that the first arguments
	to the Load and Save functions are actually of type IPropertyBag2* rather than IPropertyBag*,
	but we share the implementation to save space as this difference is not material for call out from
	Dolphin.
	"

	self
"		defineFunction: #InitNew;
		defineFunction: #Load:pErrLog:
			argumentTypes: 'IPropertyBag2* IErrorLog*';
		defineFunction: #Save:fClearDirty:fSaveAllProperties:
			argumentTypes: 'IPropertyBag2* bool bool';"
		defineFunction: #IsDirty
			returnType: 'sdword'
! !
!OS.COM.IPersistPropertyBag2 class categoriesFor: #defineFunctions!initializing!public! !

