"Filed out from Dolphin Smalltalk"!

OS.COM.IEnumUnknown
	subclass: #'OS.COM.IEnumMoniker'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IEnumMoniker guid: (OS.COM.IID fromString: '{00000102-0000-0000-c000-000000000046}')!
OS.COM.IEnumMoniker comment: '<IEnumMoniker> is a wrapper class for the custom interface ''OBJIDL.IEnumMoniker'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!OS.COM.IEnumMoniker categoriesForClass!COM-Interfaces! !
!OS.COM.IEnumMoniker class methodsFor!

defineFunctions
	"Declare the virtual function table for the receiver.
		self defineTemplate
	"

	"This method only present to prevent auto-generation from a type library"!

elementClass
	"Answer the class of element enumerated by the receiver."

	^IMoniker! !
!OS.COM.IEnumMoniker class categoriesForMethods!
defineFunctions!initializing!public! !
elementClass!constants!public! !
!

