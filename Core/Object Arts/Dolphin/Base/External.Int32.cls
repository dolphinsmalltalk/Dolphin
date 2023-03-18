"Filed out from Dolphin Smalltalk"!

External.UInt32
	subclass: #'External.Int32'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_Int32_Size' -> 16r4 }!
External.Int32 guid: (Core.GUID fromString: '{87b4c5ab-026e-11d3-9fd7-00a0cc3e4a32}')!
External.Int32 comment: '<SDWORD> is an <ExternalStructure> class to wrap the Win32 type of the same name.

SDWORD is used to represent signed 32-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	(-2**31) to: (2**31)-1
'!
!External.Int32 categoriesForClass!External-Data-Structured! !
!External.Int32 methodsFor!

isSigned
	"Answer whether the receiver holds a signed 2's complement binary value, as opposed to an unsigned binary value."

	^true!

unsignedValue: anUnsigned
	"Set the receiver's value field to the value of the unsigned positive
	integer, anUnsigned."

	bytes uint32AtOffset: 0 put: anUnsigned!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes int32AtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_value put: anInteger! !
!External.Int32 categoriesForMethods!
isSigned!public!testing! !
unsignedValue:!accessing!public! !
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!External.Int32 class methodsFor!

byteSize
	^_Int32_Size!

defineFields
	"Define the fields of the Int32 external type.
		Int32 compileDefinition
	"

	self defineField: #value
		type: (Int32Field new
				beOverride;
				yourself)!

fromUnsignedInteger: anUnsignedInteger
	"Answer a new instance of the receiver with contents copied from anInteger"

	^self new unsignedValue: anUnsignedInteger!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VM registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VM registryAt: self name put: nil! !
!External.Int32 class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
fromUnsignedInteger:!instance creation!public! !
initialize!development!initializing!private! !
uninitialize!class hierarchy-removing!private! !
!

