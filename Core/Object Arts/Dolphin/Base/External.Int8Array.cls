"Filed out from Dolphin Smalltalk"!

External.ExternalArray
	subclass: #'External.Int8Array'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Int8Array guid: (Core.GUID fromString: '{8bfb3d84-076e-4c1c-b62f-d0d7e6258c10}')!
External.Int8Array comment: 'Specialized `ExternalArray` to represent contiguous single-dimensioned arrays of 8-bit signed integers.'!
!External.Int8Array categoriesForClass!External-Data-Structured! !
!External.Int8Array methodsFor!

uncheckedAt: anInteger
	"Private - Answer an 8-bit signed <SmallInteger> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes int8AtOffset: anInteger - 1!

uncheckedAt: indexInteger put: valueInteger
	"Private - Replace the 8-bit signed integer value at the specified index in the receiver
	with the <integer> argument. No bounds checks are performed on the subscript."

	^bytes int8AtOffset: indexInteger - 1 put: valueInteger! !
!External.Int8Array categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!private! !
!

!External.Int8Array class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^Int8! !
!External.Int8Array class categoriesForMethods!
elementClass!constants!public! !
!

