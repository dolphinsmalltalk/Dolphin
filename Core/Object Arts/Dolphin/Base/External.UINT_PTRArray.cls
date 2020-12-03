"Filed out from Dolphin Smalltalk 7"!

External.ExternalArray subclass: #'External.UINT_PTRArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.UINT_PTRArray guid: (Core.GUID fromString: '{685f8656-e2d9-4365-8469-efaeb39fb86c}')!
External.UINT_PTRArray comment: 'Specialized <ExternalArray> to represent contiguous single-dimensioned arrays of machine word sized unsigned integers.'!
!External.UINT_PTRArray categoriesForClass!External-Data-Structured! !
!External.UINT_PTRArray methodsFor!

uncheckedAt: anInteger 
	"Private - Answer an 32-bit unsigned <integer> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes uintPtrAtOffset: (anInteger - 1) * VMConstants.IntPtrSize!

uncheckedAt: indexInteger put: valueInteger 
	^bytes uintPtrAtOffset: (indexInteger - 1) * VMConstants.IntPtrSize put: valueInteger! !
!External.UINT_PTRArray categoriesFor: #uncheckedAt:!accessing!private! !
!External.UINT_PTRArray categoriesFor: #uncheckedAt:put:!accessing!private! !

!External.UINT_PTRArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^UINT_PTR! !
!External.UINT_PTRArray class categoriesFor: #elementClass!constants!public! !

