"Filed out from Dolphin Smalltalk"!

External.ExternalArray
	subclass: #'External.UIntPtrArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.UIntPtrArray guid: (Core.GUID fromString: '{685f8656-e2d9-4365-8469-efaeb39fb86c}')!

External.UIntPtrArray comment: 'Specialized `ExternalArray` to represent contiguous single-dimensioned arrays of pointer-sized unsigned integers.'!

!External.UIntPtrArray categoriesForClass!External-Data-Structured! !

!External.UIntPtrArray methodsFor!

uncheckedAt: anInteger 
	"Private - Answer an 32-bit unsigned <integer> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes uintPtrAtOffset: (anInteger - 1) * VMConstants.IntPtrSize!

uncheckedAt: indexInteger put: valueInteger 
	^bytes uintPtrAtOffset: (indexInteger - 1) * VMConstants.IntPtrSize put: valueInteger! !

!External.UIntPtrArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!External.UIntPtrArray class methodsFor!

elementClass
	"Answer the class of <External.Structure> used to represent elements of the receiver."

	^UIntPtr! !

!External.UIntPtrArray class categoriesForMethods!
elementClass!constants!public! !
!

