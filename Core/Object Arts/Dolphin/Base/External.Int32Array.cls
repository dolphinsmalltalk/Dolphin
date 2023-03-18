"Filed out from Dolphin Smalltalk"!

External.ExternalArray subclass: #'External.Int32Array'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Int32Array guid: (Core.GUID fromString: '{87b4c5a7-026e-11d3-9fd7-00a0cc3e4a32}')!
External.Int32Array comment: 'Specialized `ExternalArray` to represent contiguous single-dimensioned arrays of 32-bit signed integers.'!
!External.Int32Array categoriesForClass!External-Data-Structured! !
!External.Int32Array methodsFor!

uncheckedAt: anInteger 
	"Private - Answer an 32-bit signed <integer> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes int32AtOffset: (anInteger - 1) * 4!

uncheckedAt: indexInteger put: valueInteger 
	^bytes int32AtOffset: (indexInteger - 1) * 4 put: valueInteger! !
!External.Int32Array categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!External.Int32Array class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^Int32! !
!External.Int32Array class categoriesForMethods!
elementClass!constants!public! !
!

