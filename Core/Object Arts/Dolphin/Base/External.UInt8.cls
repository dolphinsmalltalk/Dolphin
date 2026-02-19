"Filed out from Dolphin Smalltalk"!

External.AbstractInt8
	subclass: #'External.UInt8'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_UInt8_Size' -> 16r1. 'MaxValue' -> 16rFF }!

External.UInt8 guid: (Core.GUID fromString: '{87b4c5a9-026e-11d3-9fd7-00a0cc3e4a32}')!

External.UInt8 comment: '<BYTE> is an <ExternalStructure> class to wrap the Win32 type of the same name.

BYTE is used to represent unsigned 8-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	0 to: (2**8)-1	(i.e. 0 to: 255).'!

!External.UInt8 categoriesForClass!External-Data-Unstructured! !

!External.UInt8 methodsFor!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes uint8AtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_value put: anInteger! !

!External.UInt8 categoriesForMethods!
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!External.UInt8 class methodsFor!

defineFields
	"Define the fields of the UInt8 structure.
		UInt8 compileDefinition
	"

	self defineField: #value type: UInt8Field new beOverride!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VM registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VM registryAt: self name put: nil! !

!External.UInt8 class categoriesForMethods!
defineFields!public!template definition! !
initialize!development!initializing!private! !
uninitialize!class hierarchy-removing!private! !
!

