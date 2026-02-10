"Filed out from Dolphin Smalltalk"!

External.Int32Array
	subclass: #'External.BOOLArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.BOOLArray guid: (Core.GUID fromString: '{8c006591-0b31-48cf-911c-d2df015dca71}')!

External.BOOLArray comment: '`BOOLArray` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of 32-bit `BOOL` values.'!

!External.BOOLArray methodsFor!

uncheckedAt: anInteger
	"Private - Answer true if the 32-bit <integer> representing the element of the receiver at the specified <integer> index is non-zero, of false otherwise. No bounds checks are performed on the subscript."

	^(self basicUncheckedAt: anInteger) ~~ 0! !

!External.BOOLArray categoriesForMethods!
uncheckedAt:!accessing!private! !
!

!External.BOOLArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^BOOL! !

!External.BOOLArray class categoriesForMethods!
elementClass!public! !
!

