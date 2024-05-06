"Filed out from Dolphin Smalltalk"!

ExternalScalar subclass: #DOUBLE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DOUBLE guid: (GUID fromString: '{87b4c592-026e-11d3-9fd7-00a0cc3e4a32}')!

DOUBLE comment: 'DOUBLE is an <ExternalStructure> class to represent double precision (64-bit) floating point numbers in native format'!

!DOUBLE categoriesForClass!External-Data-Structured! !

!DOUBLE methodsFor!

asFloat
	"Answer a <Float> of the same value as the receiver's contents."

	^(bytes doubleAtOffset: 0)!

value
	"Answer the <Float> value of the receiver's 'value' field."

	^bytes doubleAtOffset: _OffsetOf_value!

value: aFloat
	"Set the receiver's 'value' field to the value of the argument, aFloat"

	bytes doubleAtOffset: _OffsetOf_value put: aFloat! !

!DOUBLE categoriesForMethods!
asFloat!converting!public! !
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!DOUBLE class methodsFor!

defineFields
	"Define the fields of the DOUBLE 'structure'.

		DOUBLE compileDefinition
	"

	self defineField: #value type: DOUBLEField new beOverride!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil! !

!DOUBLE class categoriesForMethods!
defineFields!public!template definition! !
initialize!development!initializing!private! !
uninitialize!class hierarchy-removing!private! !
!

