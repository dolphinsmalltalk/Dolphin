"Filed out from Dolphin Smalltalk"!

External.INTEGER subclass: #'External.BYTE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_BYTE_Size' -> 16r1
	}!
External.BYTE guid: (Core.GUID fromString: '{87b4c5a9-026e-11d3-9fd7-00a0cc3e4a32}')!
External.BYTE comment: '<BYTE> is an <ExternalStructure> class to wrap the Win32 type of the same name.

BYTE is used to represent unsigned 8-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	0 to: (2**8)-1	(i.e. 0 to: 255).'!
!External.BYTE categoriesForClass!External-Data-Unstructured! !
!External.BYTE methodsFor!

asSignedInteger
	"Answer the signed 8-bit <Integer> value of the receiver."

	^bytes sbyteAtOffset: 0!

asUnsignedInteger
	"Answer the unsigned 8-bit <Integer> value of the receiver."

	^bytes byteAtOffset: 0!

unsignedValue: anInteger
	"Set the receiver's value field to the value of the unsigned positive integer argument."

	bytes byteAtOffset: 0 put: anInteger!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes byteAtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_value put: anInteger! !
!External.BYTE categoriesForMethods!
asSignedInteger!converting!public! !
asUnsignedInteger!converting!public! !
unsignedValue:!accessing!public! !
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!External.BYTE class methodsFor!

byteSize
	^_BYTE_Size!

defineFields
	"Define the fields of the ExternalInteger 'structure'. ExternalInteger subclasses
	have a single value."

	self defineField: #value type: BYTEField new beOverride!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VM registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VM registryAt: self name put: nil! !
!External.BYTE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
initialize!development!initializing!private! !
uninitialize!class hierarchy-removing!private! !
!

