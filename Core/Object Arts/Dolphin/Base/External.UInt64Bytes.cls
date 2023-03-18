"Filed out from Dolphin Smalltalk"!

External.IntegerBytes
	variableByteSubclass: #'External.UInt64Bytes'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.UInt64Bytes guid: (Core.GUID fromString: '{f235e413-493c-4404-958f-3e1658076105}')!
External.UInt64Bytes comment: ''!
!External.UInt64Bytes categoriesForClass!External-Data-Unstructured! !
!External.UInt64Bytes methodsFor!

asInteger
	"Answer the 32-bit unsigned <integer> value of the receiver."

	^self uint64AtOffset: 0!

asSignedInteger
	"Answer the 32-bit, 2's complement, signed <integer> value of the receiver."

	^self int64AtOffset: 0!

value: anObject
	"Set the 64-bit unsigned <integer> value stored in the receiver."

	self uint64AtOffset: 0 put: anObject! !
!External.UInt64Bytes categoriesForMethods!
asInteger!converting!public! !
asSignedInteger!converting!public! !
value:!accessing!public! !
!

!External.UInt64Bytes class methodsFor!

elementSize
	"Private - Answer the size of the receiver's constituent elements in bytes."

	^8
!

valueAtAddress: anAddress 
	^anAddress asExternalAddress uint64AtOffset: 0! !
!External.UInt64Bytes class categoriesForMethods!
elementSize!constants!private! !
valueAtAddress:!helpers!private! !
!

