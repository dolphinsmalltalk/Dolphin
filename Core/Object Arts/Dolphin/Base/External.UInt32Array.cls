"Filed out from Dolphin Smalltalk"!

External.IntegerArray
	subclass: #'External.UInt32Array'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.UInt32Array guid: (Core.GUID fromString: '{87b4c5a2-026e-11d3-9fd7-00a0cc3e4a32}')!

External.UInt32Array comment: '`UInt32Array` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of 32-bit unsigned integers, i.e. `UInt32`s.'!

!External.UInt32Array categoriesForClass!External-Data-Structured! !

!External.UInt32Array methodsFor!

basicUncheckedAt: anInteger 
	"Private - Answer an 32-bit unsigned <integer> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes uint32AtOffset: (anInteger - 1) * UInt32._UInt32_Size!

basicUncheckedAt: indexInteger put: valueInteger 
	^bytes uint32AtOffset: (indexInteger - 1) * UInt32._UInt32_Size put: valueInteger! !

!External.UInt32Array categoriesForMethods!
basicUncheckedAt:!accessing!private! !
basicUncheckedAt:put:!accessing!private! !
!

!External.UInt32Array class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^UInt32! !

!External.UInt32Array class categoriesForMethods!
elementClass!constants!public! !
!

