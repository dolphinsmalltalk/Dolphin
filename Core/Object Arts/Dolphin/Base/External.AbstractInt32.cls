"Filed out from Dolphin Smalltalk"!

External.INTEGER
	subclass: #'External.AbstractInt32'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.AbstractInt32 guid: (Core.GUID fromString: '{a0e4d09a-2fd0-4081-8244-a3b81e6891f7}')!

External.AbstractInt32 isNonInstantiable: true!

External.AbstractInt32 comment: ''!

!External.AbstractInt32 methodsFor!

asSignedInteger
	"Answer the signed 32-bit <Integer> value of the receiver."

	^bytes int32AtOffset: 0!

asUnsignedInteger
	"Answer the unsigned 32-bit <Integer> value of the receiver."

	^bytes uint32AtOffset: 0!

highSWord
	"Answer the high-order signed word of the receiver. Assumes little-endian
	ordering."

	^bytes int16AtOffset: 2!

highSWord: anInteger
	"Set the high-order signed word of the receiver. Assumes little-endian
	ordering. Answer the receiver."

	bytes int16AtOffset: 2 put: anInteger!

highWord
	"Answer the high-order word of the receiver. Assumes little-endian
	ordering."

	^bytes uint16AtOffset: 2!

highWord: anInteger
	"Set the high-order word of the receiver. Assumes little-endian
	ordering. Answer the receiver."

	bytes uint16AtOffset: 2 put: anInteger!

lowSWord
	"Answer the low-order signed word of the receiver. Assumes little-endian
	ordering."

	^bytes int16AtOffset: 0!

lowSWord: anInteger
	"Answer the low-order signed word of the receiver. Assumes little-endian
	ordering. Answer the receiver."

	bytes int16AtOffset: 0 put: anInteger!

lowWord
	"Answer the low-order word of the receiver. Assumes little-endian
	ordering."

	^bytes uint16AtOffset: 0!

lowWord: anInteger
	"Answer the low-order word of the receiver. Assumes little-endian
	ordering. Answer the receiver."

	bytes uint16AtOffset: 0 put: anInteger!

unsignedValue: anUnsigned
	"Set the receiver's value field to the value of the unsigned positive
	integer, anUnsigned."

	bytes uint32AtOffset: 0 put: anUnsigned! !

!External.AbstractInt32 categoriesForMethods!
asSignedInteger!converting!public! !
asUnsignedInteger!converting!public! !
highSWord!accessing!public! !
highSWord:!accessing!public! !
highWord!accessing!public! !
highWord:!accessing!public! !
lowSWord!accessing!public! !
lowSWord:!accessing!public! !
lowWord!accessing!public! !
lowWord:!accessing!public! !
unsignedValue:!accessing!public! !
!

!External.AbstractInt32 class methodsFor!

byteSize
	"Answer the size in bytes of this structure"

	^4! !

!External.AbstractInt32 class categoriesForMethods!
byteSize!accessing!public! !
!

