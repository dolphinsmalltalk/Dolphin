"Filed out from Dolphin Smalltalk"!

External.ExternalArray subclass: #'External.DOUBLEArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.DOUBLEArray guid: (Core.GUID fromString: '{c0413e69-b874-4e6b-a120-709d0c760f0f}')!
External.DOUBLEArray comment: 'Specialized `ExternalArray` to represent contiguous single-dimensioned arrays of double-precision (64-bit) floating point numbers.'!
!External.DOUBLEArray categoriesForClass!External-Data-Structured! !
!External.DOUBLEArray methodsFor!

uncheckedAt: anInteger 
	"Private - Answer a <Float> representing the 64-bit double-precision 
	IEEE float at the specified <integer> index in the receiver. No bounds 
	checks are performed on the subscript."

	^bytes doubleAtOffset: (anInteger - 1) * VMConstants.DoubleSize!

uncheckedAt: anInteger put: aFloat 
	"Private - Replace the double-precision floating point value at the specified index in the receiver
	with the <Float> argument."

	^bytes doubleAtOffset: (anInteger - 1) * VMConstants.DoubleSize put: aFloat! !
!External.DOUBLEArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!External.DOUBLEArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^DOUBLE! !
!External.DOUBLEArray class categoriesForMethods!
elementClass!constants!public! !
!

