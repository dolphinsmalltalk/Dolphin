"Filed out from Dolphin Smalltalk 7"!

ExternalArray subclass: #SBYTEArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SBYTEArray guid: (GUID fromString: '{8bfb3d84-076e-4c1c-b62f-d0d7e6258c10}')!
SBYTEArray comment: 'Specialized <ExternalArray> to represent contiguous single-dimensioned arrays of 8-bit signed integers.'!
!SBYTEArray categoriesForClass!External-Data-Structured! !
!SBYTEArray methodsFor!

uncheckedAt: anInteger
	"Private - Answer an 8-bit signed <SmallInteger> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes sbyteAtOffset: anInteger - 1!

uncheckedAt: indexInteger put: valueInteger
	"Private - Replace the 8-bit signed integer value at the specified index in the receiver
	with the <integer> argument. No bounds checks are performed on the subscript."

	^bytes sbyteAtOffset: indexInteger - 1 put: valueInteger! !
!SBYTEArray categoriesFor: #uncheckedAt:!accessing!private! !
!SBYTEArray categoriesFor: #uncheckedAt:put:!private! !

!SBYTEArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^BYTE! !
!SBYTEArray class categoriesFor: #elementClass!constants!public! !

