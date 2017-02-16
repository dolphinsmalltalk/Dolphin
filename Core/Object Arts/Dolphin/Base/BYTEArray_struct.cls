"Filed out from Dolphin Smalltalk 7"!

ExternalArray subclass: #BYTEArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BYTEArray guid: (GUID fromString: '{8ABCB092-31C2-4291-942B-A51C59AD2C0E}')!
BYTEArray comment: 'Specialized <ExternalArray> to represent contiguous single-dimensioned arrays of 8-bit unsigned integers.'!
!BYTEArray categoriesForClass!External-Data-Structured! !
!BYTEArray methodsFor!

uncheckedAt: anInteger
	"Private - Answer an 8-bit unsigned <SmallInteger> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes byteAtOffset: anInteger - 1!

uncheckedAt: indexInteger put: valueInteger
	"Private - Replace the 8-bit unsigned integer value at the specified index in the receiver
	with the <integer> argument. No bounds checks are performed on the subscript."

	^bytes byteAtOffset: indexInteger - 1 put: valueInteger! !
!BYTEArray categoriesFor: #uncheckedAt:!accessing!private! !
!BYTEArray categoriesFor: #uncheckedAt:put:!accessing!private! !

!BYTEArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^BYTE!

fileOutStem
	^super fileOutStem, '_struct'! !
!BYTEArray class categoriesFor: #elementClass!constants!public! !
!BYTEArray class categoriesFor: #fileOutStem!development!private!source filing! !

