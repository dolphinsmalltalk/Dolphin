"Filed out from Dolphin Smalltalk 7"!

IEnumXXXX subclass: #IEnumVARIANT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IEnumVARIANT guid: (IID fromString: '{00020404-0000-0000-c000-000000000046}')!
IEnumVARIANT comment: '<IEnumVARIANT> is a wrapper class for the custom interface ''stdole.IEnumVARIANT'' from type information in the ''OLE Automation'' library. It contains methods to invoke the member functions exposed by that interface.

Implementation Notes: We have to be careful here to manage the lifetime of the VARIANTs correctly. This necessitates overrides of a couple of superclass methods in order to make sure that the objects/collections answered have a lifetime independent of the buffer originally used to retrieve them with the interface Next() function. It is also convenient to immediately convert the variants to their underlying value.

'!
!IEnumVARIANT categoriesForClass!COM-Interfaces! !
!IEnumVARIANT methodsFor!

nextAvailable
	"Answer the next element from the receiver, or nil if there are
	no more elements.
	Implementation Note: Override to answer the underlying value
	of the variant. Note that the result of the superclass implementation
	is in this case a valid standalone variant which we can free explicitly
	to reduce finalization load."

	| next |
	next := super nextAvailable.
	^next isNil ifFalse: [ | value |
		value := next value.
		next free.
		value]!

nextAvailable: anInteger
	"Answer a collection of the next anInteger elements from the receiver,
	or as many as remain if fewer.
	Implementation Note: Override to answer the values of the variants.
	Note that the superclass implementation returns a StructureArray of
	VARIANT which will decompose into a set of VARIANT references
	which are only valid for as long as the original StructureArray remains
	alive. The value collection that we return is, however, independent."

	| elements answer |
	elements := super nextAvailable: anInteger.
	answer := elements collect: [:e | e value].
	elements free.
	^answer! !
!IEnumVARIANT categoriesFor: #nextAvailable!accessing!public! !
!IEnumVARIANT categoriesFor: #nextAvailable:!accessing!public! !

!IEnumVARIANT class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'stdole.IEnumVARIANT'
		IEnumVARIANT defineTemplate
	"

	"This method only present to prevent auto-generation from stdole type library"!

elementClass
	"Answer the class of element enumerated by the receiver."

	^VARIANT! !
!IEnumVARIANT class categoriesFor: #defineFunctions!initializing!public! !
!IEnumVARIANT class categoriesFor: #elementClass!constants!public! !

