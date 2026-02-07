"Filed out from Dolphin Smalltalk"!

External.AbstractInt16
	subclass: #'External.UInt16'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_UInt16_Size' -> 16r2. 'MaxValue' -> 16rFFFF }!

External.UInt16 guid: (Core.GUID fromString: '{87b4c5ad-026e-11d3-9fd7-00a0cc3e4a32}')!

External.UInt16 comment: '`UInt16` is an `External.Structure` class to wrap 16-bit unsigned integer values.

The range of integer values that can be represented by instances of this class is defined by the interval:
	0 to: (2**16)-1'!

!External.UInt16 categoriesForClass!External-Data-Unstructured! !

!External.UInt16 methodsFor!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes uint16AtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_value put: anInteger! !

!External.UInt16 categoriesForMethods!
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!External.UInt16 class methodsFor!

byteSize
	^_UInt16_Size!

defineFields
	"Define the fields of the ExternalInteger 'structure'. ExternalInteger subclasses
	have a single value."

	self defineField: #value type: UInt16Field new beOverride!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VM registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VM registryAt: self name put: nil! !

!External.UInt16 class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
initialize!development!initializing!private! !
uninitialize!class hierarchy-removing!private! !
!

