"Filed out from Dolphin Smalltalk"!

External.ExternalArray
	subclass: #'External.UInt64Array'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.UInt64Array guid: (Core.GUID fromString: '{30b15792-8900-42fe-bfac-7a1da8247369}')!

External.UInt64Array comment: '`UInt64Array` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of 64-bit unsigned integers, i.e. `UInt64`s.'!

!External.UInt64Array methodsFor!

uncheckedAt: anInteger 
	"Private - Answer an 64-bit signed <integer> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes uint64AtOffset: (anInteger - 1) * UInt64._UInt64_Size!

uncheckedAt: indexInteger put: valueInteger 
	^bytes uint64AtOffset: (indexInteger - 1) * UInt64._UInt64_Size put: valueInteger! !

!External.UInt64Array categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!External.UInt64Array class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^UInt64! !

!External.UInt64Array class categoriesForMethods!
elementClass!constants!public! !
!

