"Filed out from Dolphin Smalltalk"!

External.Int16Array
	subclass: #'OS.COM.VARIANT_BOOLArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.VARIANT_BOOLArray guid: (Core.GUID fromString: '{8c006591-0b31-48cf-911c-d2df015dca71}')!

OS.COM.VARIANT_BOOLArray comment: '`VARIANT_BOOLArray` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of 16-bit `VARIANT_BOOL` values.

`VARIANT_BOOL` is the native representation of booleans in OLE Automation. It is unusual in being a 16-bit representation where all bits are expected to be set (i.e. -1) to represent true, and all bits cleared (i.e. 0) to represent false. See also `BOOLArray`, which uses a representation more akin to what one might expect in a C/C++ based API.'!

!OS.COM.VARIANT_BOOLArray methodsFor!

uncheckedAt: anInteger
	"Private - Answer true if the 16-bit <integer> representing the element of the receiver at the specified <integer> index is non-zero, of false otherwise. No bounds checks are performed on the subscript."

	^(self basicUncheckedAt: anInteger) ~~ 0!

uncheckedAt: anInteger put: aBoolean
	self basicUncheckedAt: anInteger put: (aBoolean ifTrue: [-1] ifFalse: [0]).
	^aBoolean! !

!OS.COM.VARIANT_BOOLArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!OS.COM.VARIANT_BOOLArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^VARIANT_BOOL! !

!OS.COM.VARIANT_BOOLArray class categoriesForMethods!
elementClass!public! !
!

