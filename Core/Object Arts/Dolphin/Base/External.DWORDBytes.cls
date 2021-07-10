"Filed out from Dolphin Smalltalk"!

External.IntegerBytes variableByteSubclass: #'External.DWORDBytes'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.DWORDBytes guid: (Core.GUID fromString: '{87b4c516-026e-11d3-9fd7-00a0cc3e4a32}')!
External.DWORDBytes comment: ''!
!External.DWORDBytes categoriesForClass!External-Data-Unstructured! !
!External.DWORDBytes methodsFor!

asDword
	"Answer the receiver in a form suitable for passing/returning as 
	a 32-bit value."

	^self value!

asInteger
	"Answer the 32-bit unsigned <integer> value of the receiver."

	^self dwordAtOffset: 0!

asSignedInteger
	"Answer the 32-bit, 2's complement, signed <integer> value of the receiver."

	^self sdwordAtOffset: 0!

value: anObject
	"Set the 32-bit unsigned <integer> value stored in the receiver."

	self dwordAtOffset: 0 put: anObject! !
!External.DWORDBytes categoriesForMethods!
asDword!converting!public! !
asInteger!converting!public! !
asSignedInteger!converting!public! !
value:!accessing!public! !
!

!External.DWORDBytes class methodsFor!

elementSize
	"Private - Answer the size of the receiver's constituent elements in bytes."

	^4
!

valueAtAddress: anAddress 
	^anAddress asExternalAddress dwordAtOffset: 0! !
!External.DWORDBytes class categoriesForMethods!
elementSize!constants!private! !
valueAtAddress:!helpers!private! !
!

