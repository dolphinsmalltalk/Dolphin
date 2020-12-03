"Filed out from Dolphin Smalltalk 7"!

External.SCALAR subclass: #'External.FLOAT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.FLOAT guid: (Core.GUID fromString: '{87b4c595-026e-11d3-9fd7-00a0cc3e4a32}')!
External.FLOAT comment: 'FLOAT is an <ExternalStructure> class to represent single precision (32-bit) floating point numbers in native format.

Single precision floats can be used to represent numbers with magnitudes between 1.17549e-038 and 3.40282e+038, but only with about 6 digits of precision.'!
!External.FLOAT categoriesForClass!External-Data-Structured! !
!External.FLOAT methodsFor!

asFloat
	"Answer a <Float> of the same value as the receiver's contents."

	^(bytes floatAtOffset: 0)!

value
	"Answer the <Float> value of the receiver's 'value' field."

	^bytes floatAtOffset: _OffsetOf_value!

value: aFloat
	"Set the receiver's 'value' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_value put: aFloat! !
!External.FLOAT categoriesFor: #asFloat!converting!public! !
!External.FLOAT categoriesFor: #value!**compiled accessors**!public! !
!External.FLOAT categoriesFor: #value:!**compiled accessors**!public! !

!External.FLOAT class methodsFor!

defineFields
	"Define the fields of the FLOAT 'structure'.

		FLOAT  compileDefinition
	"

	self defineField: #value type: FLOATField new beOverride!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

maximum
	^self fromBytes: #[255 255 127 127]!

minimum
	^self fromBytes: #[0 0 128 0]
!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil! !
!External.FLOAT class categoriesFor: #defineFields!public!template definition! !
!External.FLOAT class categoriesFor: #initialize!development!initializing!private! !
!External.FLOAT class categoriesFor: #maximum!constants!public! !
!External.FLOAT class categoriesFor: #minimum!constants!public! !
!External.FLOAT class categoriesFor: #uninitialize!class hierarchy-removing!private! !

