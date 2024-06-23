"Filed out from Dolphin Smalltalk"!

External.IntegerBytes
	variableByteSubclass: #'External.UInt32Bytes'
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
	^(self int32AtOffset: 0) ~~ 0!

asInteger
	"Answer the 32-bit unsigned <integer> value of the receiver."

	^self uint32AtOffset: 0!

asSignedInteger
	"Answer the 32-bit, 2's complement, signed <integer> value of the receiver."

	^self int32AtOffset: 0!

asUInt32
	"Answer the receiver in a form suitable for passing/returning as 
	a 32-bit value."

	^self value!

highWord
	"Answer the high-order word of the receiver. Assumes little-endian ordering."

	^self uint16AtOffset: 2!

highWord: anInteger
	"Set the high-order word of the receiver. Assumes little-endian ordering. Answer the receiver."

	self uint16AtOffset: 2 put: anInteger!

lowWord
	"Answer the low-order word of the receiver. Assumes little-endian	ordering."

	^self uint16AtOffset: 0!

lowWord: anInteger
	"Answer the low-order word of the receiver. Assumes little-endian ordering. Answer the receiver."

	self uint16AtOffset: 0 put: anInteger!

value: anObject
	"Set the 32-bit unsigned <integer> value stored in the receiver."

	self uint32AtOffset: 0 put: anObject! !

!External.UInt32Bytes categoriesForMethods!
asBoolean!converting!public! !
asInteger!converting!public! !
asSignedInteger!converting!public! !
asUInt32!converting!public! !
highWord!accessing!public! !
highWord:!accessing!public! !
lowWord!accessing!public! !
lowWord:!accessing!public! !
value:!accessing!public! !
!

!External.UInt32Bytes class methodsFor!

elementSize
	"Private - Answer the size of the receiver's constituent elements in bytes."

	^4
!

valueAtAddress: anAddress 
	^anAddress asExternalAddress uint32AtOffset: 0! !

!External.UInt32Bytes class categoriesForMethods!
elementSize!constants!private! !
valueAtAddress:!helpers!private! !
!

