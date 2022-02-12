"Filed out from Dolphin Smalltalk"!

External.SCALAR subclass: #'External.DOUBLE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_DOUBLE_Size' -> 16r8
	}!
External.DOUBLE guid: (Core.GUID fromString: '{87b4c592-026e-11d3-9fd7-00a0cc3e4a32}')!
External.DOUBLE comment: 'DOUBLE is an <ExternalStructure> class to represent double precision (64-bit) floating point numbers in native format'!
!External.DOUBLE categoriesForClass!External-Data-Structured! !
!External.DOUBLE methodsFor!

asFloat
	"Answer a <Float> of the same value as the receiver's contents."

	^(bytes doubleAtOffset: 0)!

value
	"Answer the <Float> value of the receiver's 'value' field."

	^bytes doubleAtOffset: _OffsetOf_value!

value: aFloat
	"Set the receiver's 'value' field to the value of the argument, aFloat"

	bytes doubleAtOffset: _OffsetOf_value put: aFloat! !
!External.DOUBLE categoriesForMethods!
asFloat!converting!public! !
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!External.DOUBLE class methodsFor!

byteSize
	^_DOUBLE_Size!

defineFields
	"Define the fields of the DOUBLE 'structure'.

		DOUBLE compileDefinition
	"

	self defineField: #value type: DOUBLEField new beOverride!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VM registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VM registryAt: self name put: nil! !
!External.DOUBLE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
initialize!development!initializing!private! !
uninitialize!class hierarchy-removing!private! !
!

