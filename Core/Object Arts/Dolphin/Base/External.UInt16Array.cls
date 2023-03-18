"Filed out from Dolphin Smalltalk"!

External.ExternalArray subclass: #'External.UInt16Array'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.UInt16Array guid: (Core.GUID fromString: '{87b4c5a6-026e-11d3-9fd7-00a0cc3e4a32}')!
External.UInt16Array comment: 'Specialized `ExternalArray` to represent contiguous single-dimensioned arrays of 16-bit unsigned integers.'!
!External.UInt16Array categoriesForClass!External-Data-Structured! !
!External.UInt16Array methodsFor!

uncheckedAt: anInteger 
	"Private - Answer an 16-bit unsigned <SmallInteger> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes uint16AtOffset: anInteger + anInteger - 2!

uncheckedAt: indexInteger put: valueInteger 
	"Private - Replace the 16-bit unsigned integer value at the specified index in the receiver
	with the <integer> argument. No bounds checks are performed on the subscript."

	^bytes uint16AtOffset: indexInteger + indexInteger - 2 put: valueInteger! !
!External.UInt16Array categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!External.UInt16Array class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^UInt16! !
!External.UInt16Array class categoriesForMethods!
elementClass!constants!public! !
!

