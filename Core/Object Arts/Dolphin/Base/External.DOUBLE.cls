"Filed out from Dolphin Smalltalk 7"!

External.SCALAR subclass: #'External.DOUBLE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
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
!External.DOUBLE categoriesFor: #asFloat!converting!public! !
!External.DOUBLE categoriesFor: #value!**compiled accessors**!public! !
!External.DOUBLE categoriesFor: #value:!**compiled accessors**!public! !

!External.DOUBLE class methodsFor!

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
!External.DOUBLE class categoriesFor: #defineFields!public!template definition! !
!External.DOUBLE class categoriesFor: #initialize!development!initializing!private! !
!External.DOUBLE class categoriesFor: #uninitialize!class hierarchy-removing!private! !

