"Filed out from Dolphin Smalltalk"!

External.ExternalArray subclass: #'External.SDWORDArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.SDWORDArray guid: (Core.GUID fromString: '{87b4c5a7-026e-11d3-9fd7-00a0cc3e4a32}')!
External.SDWORDArray comment: 'Specialized <ExternalArray> to represent contiguous single-dimensioned arrays of 32-bit signed integers.'!
!External.SDWORDArray categoriesForClass!External-Data-Structured! !
!External.SDWORDArray methodsFor!

uncheckedAt: anInteger 
	"Private - Answer an 32-bit signed <integer> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes sdwordAtOffset: (anInteger - 1) * 4!

uncheckedAt: indexInteger put: valueInteger 
	^bytes sdwordAtOffset: (indexInteger - 1) * 4 put: valueInteger! !
!External.SDWORDArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!External.SDWORDArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^SDWORD! !
!External.SDWORDArray class categoriesForMethods!
elementClass!constants!public! !
!

