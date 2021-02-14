"Filed out from Dolphin Smalltalk 7"!

OS.COM.IEnumXXXX subclass: #'OS.COM.IEnumString'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IEnumString guid: (OS.COM.IID fromString: '{00000101-0000-0000-c000-000000000046}')!
OS.COM.IEnumString comment: '`OS.COM.IEnumString` is a wrapper class for the custom interface ''OBJIDL.IEnumString'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!OS.COM.IEnumString categoriesForClass!COM-Interfaces! !
!OS.COM.IEnumString class methodsFor!

defineFunctions
	"Declare the virtual function table for the receiver.
		self defineTemplate
	"

	"This method only present to prevent auto-generation from a type library"!

elementClass
	"Answer the class of element enumerated by the receiver."

	^LPWSTR! !
!OS.COM.IEnumString class categoriesFor: #defineFunctions!initializing!public! !
!OS.COM.IEnumString class categoriesFor: #elementClass!constants!public! !

