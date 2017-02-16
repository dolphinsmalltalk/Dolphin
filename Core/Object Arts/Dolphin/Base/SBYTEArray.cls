"Filed out from Dolphin Smalltalk 7"!

ExternalArray subclass: #SBYTEArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SBYTEArray guid: (GUID fromString: '{8BFB3D84-076E-4C1C-B62F-D0D7E6258C10}')!
SBYTEArray comment: ''!
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
!SBYTEArray categoriesFor: #uncheckedAt:put:!accessing!private! !

!SBYTEArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^BYTE! !
!SBYTEArray class categoriesFor: #elementClass!constants!public! !

