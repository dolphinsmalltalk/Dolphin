"Filed out from Dolphin Smalltalk"!

External.ExternalArray subclass: #'External.DWORDArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.DWORDArray guid: (Core.GUID fromString: '{87b4c5a2-026e-11d3-9fd7-00a0cc3e4a32}')!
External.DWORDArray comment: 'Specialized <ExternalArray> to represent contiguous single-dimensioned arrays of 32-bit unsigned integers.'!
!External.DWORDArray categoriesForClass!External-Data-Structured! !
!External.DWORDArray methodsFor!

uncheckedAt: anInteger 
	"Private - Answer an 32-bit unsigned <integer> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes dwordAtOffset: (anInteger - 1) * 4!

uncheckedAt: indexInteger put: valueInteger 
	^bytes dwordAtOffset: (indexInteger - 1) * 4 put: valueInteger! !
!External.DWORDArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!External.DWORDArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^DWORD! !
!External.DWORDArray class categoriesForMethods!
elementClass!constants!public! !
!

