"Filed out from Dolphin Smalltalk 7"!

IEnumXXXX subclass: #IEnumString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IEnumString guid: (IID fromString: '{00000101-0000-0000-c000-000000000046}')!
IEnumString comment: '<IEnumString> is a wrapper class for the custom interface ''OBJIDL.IEnumString'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IEnumString categoriesForClass!COM-Interfaces! !
!IEnumString class methodsFor!

defineFunctions
	"Declare the virtual function table for the receiver.
		self defineTemplate
	"

	"This method only present to prevent auto-generation from a type library"!

elementClass
	"Answer the class of element enumerated by the receiver."

	^LPWSTR! !
!IEnumString class categoriesFor: #defineFunctions!initializing!public! !
!IEnumString class categoriesFor: #elementClass!constants!public! !

