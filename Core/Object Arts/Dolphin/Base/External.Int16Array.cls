"Filed out from Dolphin Smalltalk"!

External.ExternalArray
	subclass: #'External.Int16Array'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Int16Array guid: (Core.GUID fromString: '{87b4c5a8-026e-11d3-9fd7-00a0cc3e4a32}')!

External.Int16Array comment: 'Specialized `ExternalArray` to represent contiguous single-dimensioned arrays of 16-bit signed integers.'!

!External.Int16Array categoriesForClass!External-Data-Structured! !

!External.Int16Array methodsFor!

uncheckedAt: anInteger 
	"Private - Answer an 16-bit signed <SmallInteger> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes int16AtOffset: anInteger + anInteger - 2!

uncheckedAt: indexInteger put: valueInteger 
	"Private - Replace the 16-bit signed integer value at the specified index in the receiver
	with the <integer> argument. No bounds checks are performed on the subscript."

	^bytes int16AtOffset: indexInteger + indexInteger - 2 put: valueInteger! !

!External.Int16Array categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!External.Int16Array class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^Int16! !

!External.Int16Array class categoriesForMethods!
elementClass!constants!public! !
!

