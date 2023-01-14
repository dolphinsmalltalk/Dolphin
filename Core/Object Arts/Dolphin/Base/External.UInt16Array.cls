"Filed out from Dolphin Smalltalk"!

External.ExternalArray subclass: #'External.WORDArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.WORDArray guid: (Core.GUID fromString: '{87b4c5a6-026e-11d3-9fd7-00a0cc3e4a32}')!
External.WORDArray comment: 'Specialized <ExternalArray> to represent contiguous single-dimensioned arrays of 16-bit unsigned integers.'!
!External.WORDArray categoriesForClass!External-Data-Structured! !
!External.WORDArray methodsFor!

uncheckedAt: anInteger 
	"Private - Answer an 16-bit unsigned <SmallInteger> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes wordAtOffset: anInteger + anInteger - 2!

uncheckedAt: indexInteger put: valueInteger 
	"Private - Replace the 16-bit unsigned integer value at the specified index in the receiver
	with the <integer> argument. No bounds checks are performed on the subscript."

	^bytes wordAtOffset: indexInteger + indexInteger - 2 put: valueInteger! !
!External.WORDArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!External.WORDArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^WORD! !
!External.WORDArray class categoriesForMethods!
elementClass!constants!public! !
!

