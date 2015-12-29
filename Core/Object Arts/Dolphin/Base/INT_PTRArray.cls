"Filed out from Dolphin Smalltalk X6.1"!

ExternalArray subclass: #INT_PTRArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
INT_PTRArray guid: (GUID fromString: '{23B3BFA9-80D2-4211-A5CC-5E739D62812B}')!
INT_PTRArray comment: 'Specialized <ExternalArray> to represent contiguous single-dimensioned arrays of machine word sized signed integers.'!
!INT_PTRArray categoriesForClass!External-Data-Structured! !
!INT_PTRArray methodsFor!

uncheckedAt: anInteger 
	"Private - Answer an 32-bit unsigned <integer> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes intPtrAtOffset: (anInteger - 1) * VMConstants.IntPtrSize!

uncheckedAt: indexInteger put: valueInteger 
	^bytes intPtrAtOffset: (indexInteger - 1) * VMConstants.IntPtrSize put: valueInteger! !
!INT_PTRArray categoriesFor: #uncheckedAt:!accessing!private! !
!INT_PTRArray categoriesFor: #uncheckedAt:put:!accessing!private! !

!INT_PTRArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^INT_PTR! !
!INT_PTRArray class categoriesFor: #elementClass!constants!public! !

