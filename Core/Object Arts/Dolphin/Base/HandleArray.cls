"Filed out from Dolphin Smalltalk 7"!

UINT_PTRArray subclass: #HandleArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
HandleArray guid: (GUID fromString: '{1452d19c-be37-42aa-838e-ff2156d8ed64}')!
HandleArray comment: 'Specialized <ExternalArray> to represent contiguous single-dimensioned arrays of handles. Note that these could be 32 or 64-bit, depending on the host OS.'!
!HandleArray categoriesForClass!External-Data-Structured! !
!HandleArray methodsFor!

uncheckedAt: anInteger 
	"Private - Answer a machine-word sized handle representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^(super uncheckedAt: anInteger) asExternalHandle!

uncheckedAt: indexInteger put: anExternalHandle 
	super uncheckedAt: indexInteger put: anExternalHandle asInteger.
	^anExternalHandle! !
!HandleArray categoriesFor: #uncheckedAt:!accessing!private! !
!HandleArray categoriesFor: #uncheckedAt:put:!accessing!private! !

!HandleArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^ExternalHandle! !
!HandleArray class categoriesFor: #elementClass!constants!public! !

