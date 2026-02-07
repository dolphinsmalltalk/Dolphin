"Filed out from Dolphin Smalltalk"!

External.IntegerArray
	subclass: #'External.Int64Array'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Int64Array guid: (Core.GUID fromString: '{7e615a19-da3c-45b4-bf5a-16020694cd39}')!

External.Int64Array comment: '`Int64Array` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of 64-bit signed integers.'!

!External.Int64Array methodsFor!

basicUncheckedAt: anInteger 
	"Private - Answer an 64-bit signed <integer> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes int64AtOffset: (anInteger - 1) * Int64._Int64_Size!

basicUncheckedAt: indexInteger put: valueInteger
	^bytes int64AtOffset: (indexInteger - 1) * Int64._Int64_Size put: valueInteger asInteger! !

!External.Int64Array categoriesForMethods!
basicUncheckedAt:!accessing!private! !
basicUncheckedAt:put:!accessing!private! !
!

!External.Int64Array class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^Int64! !

!External.Int64Array class categoriesForMethods!
elementClass!constants!public! !
!

