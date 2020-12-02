"Filed out from Dolphin Smalltalk 7"!

ExternalArray subclass: #DWORDArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DWORDArray guid: (GUID fromString: '{87b4c5a2-026e-11d3-9fd7-00a0cc3e4a32}')!
DWORDArray comment: 'Specialized <ExternalArray> to represent contiguous single-dimensioned arrays of 32-bit unsigned integers.'!
!DWORDArray categoriesForClass!External-Data-Structured! !
!DWORDArray methodsFor!

uncheckedAt: anInteger 
	"Private - Answer an 32-bit unsigned <integer> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes dwordAtOffset: (anInteger - 1) * 4!

uncheckedAt: indexInteger put: valueInteger 
	^bytes dwordAtOffset: (indexInteger - 1) * 4 put: valueInteger! !
!DWORDArray categoriesFor: #uncheckedAt:!accessing!private! !
!DWORDArray categoriesFor: #uncheckedAt:put:!accessing!private! !

!DWORDArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^DWORD! !
!DWORDArray class categoriesFor: #elementClass!constants!public! !

