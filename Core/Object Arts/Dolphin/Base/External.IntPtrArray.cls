"Filed out from Dolphin Smalltalk"!

External.ExternalArray
	subclass: #'External.IntPtrArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.IntPtrArray guid: (Core.GUID fromString: '{23b3bfa9-80d2-4211-a5cc-5e739d62812b}')!

External.IntPtrArray comment: 'Specialized `ExternalArray` to represent contiguous single-dimensioned arrays of pointer-sized signed integers.'!

!External.IntPtrArray categoriesForClass!External-Data-Structured! !

!External.IntPtrArray methodsFor!

uncheckedAt: anInteger 
	"Private - Answer an 32-bit unsigned <integer> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes intPtrAtOffset: (anInteger - 1) * VMConstants.IntPtrSize!

uncheckedAt: indexInteger put: valueInteger 
	^bytes intPtrAtOffset: (indexInteger - 1) * VMConstants.IntPtrSize put: valueInteger! !

!External.IntPtrArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!External.IntPtrArray class methodsFor!

elementClass
	"Answer the class of <External.Structure> used to represent elements of the receiver."

	^IntPtr! !

!External.IntPtrArray class categoriesForMethods!
elementClass!constants!public! !
!

