"Filed out from Dolphin Smalltalk"!

External.UInt16
	subclass: #'External.Int16'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_Int16_Size' -> 16r2 }!
External.Int16 guid: (Core.GUID fromString: '{87b4c5ac-026e-11d3-9fd7-00a0cc3e4a32}')!
External.Int16 comment: '<SWORD> is an <ExternalStructure> class to wrap the Win32 type of the same name.

SWORD is used to represent signed 16-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	(-2**15) to: (2**15)-1'!
!External.Int16 categoriesForClass!External-Data-Structured! !
!External.Int16 methodsFor!

isSigned
	"Answer whether the receiver holds a signed 2's complement binary value, as opposed to an unsigned binary value."

	^true!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes int16AtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_value put: anInteger! !
!External.Int16 categoriesForMethods!
isSigned!public!testing! !
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!External.Int16 class methodsFor!

byteSize
	^_Int16_Size!

defineFields
	"Define the fields of the ExternalInteger 'structure'. ExternalInteger subclasses
	have a single value."

	self defineField: #value type: Int16Field new beOverride!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VM registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VM registryAt: self name put: nil! !
!External.Int16 class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
initialize!development!initializing!private! !
uninitialize!class hierarchy-removing!private! !
!

