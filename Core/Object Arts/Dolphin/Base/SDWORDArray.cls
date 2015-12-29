"Filed out from Dolphin Smalltalk X6.1"!

ExternalArray subclass: #SDWORDArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SDWORDArray guid: (GUID fromString: '{87B4C5A7-026E-11D3-9FD7-00A0CC3E4A32}')!
SDWORDArray comment: 'Specialized <ExternalArray> to represent contiguous single-dimensioned arrays of 32-bit signed integers.'!
!SDWORDArray categoriesForClass!External-Data-Structured! !
!SDWORDArray methodsFor!

uncheckedAt: anInteger 
	"Private - Answer an 32-bit signed <integer> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes sdwordAtOffset: (anInteger - 1) * 4!

uncheckedAt: indexInteger put: valueInteger 
	^bytes sdwordAtOffset: (indexInteger - 1) * 4 put: valueInteger! !
!SDWORDArray categoriesFor: #uncheckedAt:!accessing!private! !
!SDWORDArray categoriesFor: #uncheckedAt:put:!accessing!private! !

!SDWORDArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^SDWORD! !
!SDWORDArray class categoriesFor: #elementClass!constants!public! !

