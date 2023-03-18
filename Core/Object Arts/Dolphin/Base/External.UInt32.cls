"Filed out from Dolphin Smalltalk"!

External.INTEGER subclass: #'External.UInt32'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_UInt32_Size' -> 16r4
	}!
External.UInt32 guid: (Core.GUID fromString: '{87b4c5aa-026e-11d3-9fd7-00a0cc3e4a32}')!
External.UInt32 comment: '<DWORD> is an <ExternalStructure> class to wrap the Win32 type of the same name.

DWORD is used to represent unsigned 32-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	0 to: (2**32)-1'!
!External.UInt32 categoriesForClass!External-Data-Unstructured! !
!External.UInt32 methodsFor!

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

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes uint32AtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_value put: anInteger! !
!External.UInt32 categoriesForMethods!
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
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!External.UInt32 class methodsFor!

byteSize
	^_UInt32_Size!

defineFields
	"Define the fields of the ExternalInteger 'structure'. ExternalInteger subclasses
	have a single value."

	self defineField: #value type: UInt32Field new beOverride!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VM registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VM registryAt: self name put: nil! !
!External.UInt32 class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
initialize!development!initializing!private! !
uninitialize!class hierarchy-removing!private! !
!

