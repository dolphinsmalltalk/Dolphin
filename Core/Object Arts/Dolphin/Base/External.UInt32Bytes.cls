"Filed out from Dolphin Smalltalk"!

External.IntegerBytes variableByteSubclass: #'External.UInt32Bytes'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.UInt32Bytes guid: (Core.GUID fromString: '{87b4c516-026e-11d3-9fd7-00a0cc3e4a32}')!
External.UInt32Bytes comment: ''!
!External.UInt32Bytes categoriesForClass!External-Data-Unstructured! !
!External.UInt32Bytes methodsFor!

asBoolean
	^(self sdwordAtOffset: 0) ~~ 0!

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
!External.UInt32Bytes categoriesForMethods!
asBoolean!converting!public! !
asDword!converting!public! !
asInteger!converting!public! !
asSignedInteger!converting!public! !
value:!accessing!public! !
!

!External.UInt32Bytes class methodsFor!

elementSize
	"Private - Answer the size of the receiver's constituent elements in bytes."

	^4
!

valueAtAddress: anAddress 
	^anAddress asExternalAddress dwordAtOffset: 0! !
!External.UInt32Bytes class categoriesForMethods!
elementSize!constants!private! !
valueAtAddress:!helpers!private! !
!

