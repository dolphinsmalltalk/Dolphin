"Filed out from Dolphin Smalltalk"!

External.ExternalArray subclass: #'External.SBYTEArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.SBYTEArray guid: (Core.GUID fromString: '{8bfb3d84-076e-4c1c-b62f-d0d7e6258c10}')!
External.SBYTEArray comment: 'Specialized <ExternalArray> to represent contiguous single-dimensioned arrays of 8-bit signed integers.'!
!External.SBYTEArray categoriesForClass!External-Data-Structured! !
!External.SBYTEArray methodsFor!

uncheckedAt: anInteger
	"Private - Answer an 8-bit signed <SmallInteger> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes sbyteAtOffset: anInteger - 1!

uncheckedAt: indexInteger put: valueInteger
	"Private - Replace the 8-bit signed integer value at the specified index in the receiver
	with the <integer> argument. No bounds checks are performed on the subscript."

	^bytes sbyteAtOffset: indexInteger - 1 put: valueInteger! !
!External.SBYTEArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!private! !
!

!External.SBYTEArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^SBYTE! !
!External.SBYTEArray class categoriesForMethods!
elementClass!constants!public! !
!

