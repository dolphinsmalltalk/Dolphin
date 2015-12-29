"Filed out from Dolphin Smalltalk X6.1"!

ExternalArray subclass: #WORDArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WORDArray guid: (GUID fromString: '{87B4C5A6-026E-11D3-9FD7-00A0CC3E4A32}')!
WORDArray comment: 'Specialized <ExternalArray> to represent contiguous single-dimensioned arrays of 16-bit unsigned integers.'!
!WORDArray categoriesForClass!External-Data-Structured! !
!WORDArray methodsFor!

uncheckedAt: anInteger 
	"Private - Answer an 16-bit unsigned <SmallInteger> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes wordAtOffset: anInteger + anInteger - 2!

uncheckedAt: indexInteger put: valueInteger 
	"Private - Replace the 16-bit unsigned integer value at the specified index in the receiver
	with the <integer> argument. No bounds checks are performed on the subscript."

	^bytes wordAtOffset: indexInteger + indexInteger - 2 put: valueInteger! !
!WORDArray categoriesFor: #uncheckedAt:!accessing!private! !
!WORDArray categoriesFor: #uncheckedAt:put:!accessing!private! !

!WORDArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^WORD! !
!WORDArray class categoriesFor: #elementClass!constants!public! !

