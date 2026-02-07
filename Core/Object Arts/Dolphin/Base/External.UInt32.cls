"Filed out from Dolphin Smalltalk"!

External.AbstractInt32
	subclass: #'External.UInt32'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_UInt32_Size' -> 16r4. 'MaxValue' -> 16rFFFFFFFF }!

External.UInt32 guid: (Core.GUID fromString: '{87b4c5aa-026e-11d3-9fd7-00a0cc3e4a32}')!

External.UInt32 comment: '<DWORD> is an <ExternalStructure> class to wrap the Win32 type of the same name.

DWORD is used to represent unsigned 32-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	0 to: (2**32)-1'!

!External.UInt32 categoriesForClass!External-Data-Unstructured! !

!External.UInt32 methodsFor!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes uint32AtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_value put: anInteger! !

!External.UInt32 categoriesForMethods!
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!External.UInt32 class methodsFor!

byteSize
	^_UInt32_Size!

defineFields
	"Define the fields of the UInt32 'structure'. ExternalInteger subclasses have a single value.
		UInt32 compileDefinition
	"

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

