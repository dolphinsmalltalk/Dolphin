"Filed out from Dolphin Smalltalk 7"!

External.ExternalArray subclass: #'External.INT_PTRArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.INT_PTRArray guid: (Core.GUID fromString: '{23b3bfa9-80d2-4211-a5cc-5e739d62812b}')!
External.INT_PTRArray comment: 'Specialized <ExternalArray> to represent contiguous single-dimensioned arrays of machine word sized signed integers.'!
!External.INT_PTRArray categoriesForClass!External-Data-Structured! !
!External.INT_PTRArray methodsFor!

uncheckedAt: anInteger 
	"Private - Answer an 32-bit unsigned <integer> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes intPtrAtOffset: (anInteger - 1) * VMConstants.IntPtrSize!

uncheckedAt: indexInteger put: valueInteger 
	^bytes intPtrAtOffset: (indexInteger - 1) * VMConstants.IntPtrSize put: valueInteger! !
!External.INT_PTRArray categoriesFor: #uncheckedAt:!accessing!private! !
!External.INT_PTRArray categoriesFor: #uncheckedAt:put:!accessing!private! !

!External.INT_PTRArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^INT_PTR! !
!External.INT_PTRArray class categoriesFor: #elementClass!constants!public! !

