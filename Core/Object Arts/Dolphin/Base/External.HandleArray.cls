"Filed out from Dolphin Smalltalk"!

External.UIntPtrArray
	subclass: #'External.HandleArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.HandleArray guid: (Core.GUID fromString: '{1452d19c-be37-42aa-838e-ff2156d8ed64}')!
External.HandleArray comment: 'Specialized `ExternalArray` to represent contiguous single-dimensioned arrays of handles. Note that these could be 32 or 64-bit, depending on the host OS.'!
!External.HandleArray categoriesForClass!External-Data-Structured! !
!External.HandleArray methodsFor!

uncheckedAt: anInteger 
	"Private - Answer a machine-word sized handle representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^(super uncheckedAt: anInteger) asExternalHandle!

uncheckedAt: indexInteger put: anExternalHandle 
	super uncheckedAt: indexInteger put: anExternalHandle asInteger.
	^anExternalHandle! !
!External.HandleArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!External.HandleArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^External.Handle! !
!External.HandleArray class categoriesForMethods!
elementClass!constants!public! !
!

