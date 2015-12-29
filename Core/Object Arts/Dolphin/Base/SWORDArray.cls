"Filed out from Dolphin Smalltalk X6.1"!

ExternalArray subclass: #SWORDArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SWORDArray guid: (GUID fromString: '{87B4C5A8-026E-11D3-9FD7-00A0CC3E4A32}')!
SWORDArray comment: 'Specialized <ExternalArray> to represent contiguous single-dimensioned arrays of 16-bit signed integers.'!
!SWORDArray categoriesForClass!External-Data-Structured! !
!SWORDArray methodsFor!

uncheckedAt: anInteger 
	"Private - Answer an 16-bit signed <SmallInteger> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes swordAtOffset: anInteger + anInteger - 2!

uncheckedAt: indexInteger put: valueInteger 
	"Private - Replace the 16-bit signed integer value at the specified index in the receiver
	with the <integer> argument. No bounds checks are performed on the subscript."

	^bytes swordAtOffset: indexInteger + indexInteger - 2 put: valueInteger! !
!SWORDArray categoriesFor: #uncheckedAt:!accessing!private! !
!SWORDArray categoriesFor: #uncheckedAt:put:!accessing!private! !

!SWORDArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^SWORD! !
!SWORDArray class categoriesFor: #elementClass!constants!public! !

