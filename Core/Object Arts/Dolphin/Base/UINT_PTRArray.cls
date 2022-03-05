"Filed out from Dolphin Smalltalk"!

ExternalArray subclass: #UINT_PTRArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UINT_PTRArray guid: (GUID fromString: '{685f8656-e2d9-4365-8469-efaeb39fb86c}')!
UINT_PTRArray comment: 'Specialized <ExternalArray> to represent contiguous single-dimensioned arrays of machine word sized unsigned integers.'!
!UINT_PTRArray categoriesForClass!External-Data-Structured! !
!UINT_PTRArray methodsFor!

uncheckedAt: anInteger 
	"Private - Answer an 32-bit unsigned <integer> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes uintPtrAtOffset: (anInteger - 1) * VMConstants.IntPtrSize!

uncheckedAt: indexInteger put: valueInteger 
	^bytes uintPtrAtOffset: (indexInteger - 1) * VMConstants.IntPtrSize put: valueInteger! !
!UINT_PTRArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!UINT_PTRArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^UINT_PTR! !
!UINT_PTRArray class categoriesForMethods!
elementClass!constants!public! !
!

