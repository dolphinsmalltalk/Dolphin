"Filed out from Dolphin Smalltalk"!

ExternalArray subclass: #FLOATArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FLOATArray guid: (GUID fromString: '{87b4c5a3-026e-11d3-9fd7-00a0cc3e4a32}')!

FLOATArray comment: 'Specialized <ExternalArray> to represent contiguous single-dimensioned arrays of single-precision (32-bit) floating point numbers.'!

!FLOATArray categoriesForClass!External-Data-Structured! !

!FLOATArray methodsFor!

uncheckedAt: anInteger 
	"Private - Answer a <Float> representing the 32-bit single-precision 
	IEEE float at the specified <integer> index in the receiver. No bounds 
	checks are performed on the subscript."

	^bytes floatAtOffset: (anInteger - 1) * VMConstants.FloatSize!

uncheckedAt: anInteger put: aFloat 
	"Private - Replace the single-precision floating point value at the specified index in the receiver
	with the Float argument."

	^bytes floatAtOffset: (anInteger - 1) * VMConstants.FloatSize put: aFloat! !

!FLOATArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!FLOATArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^FLOAT! !

!FLOATArray class categoriesForMethods!
elementClass!constants!public! !
!

