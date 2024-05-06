"Filed out from Dolphin Smalltalk"!

ExternalScalar subclass: #FLOAT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FLOAT guid: (GUID fromString: '{87b4c595-026e-11d3-9fd7-00a0cc3e4a32}')!

FLOAT comment: 'FLOAT is an <ExternalStructure> class to represent single precision (32-bit) floating point numbers in native format.

Single precision floats can be used to represent numbers with magnitudes between 1.17549e-038 and 3.40282e+038, but only with about 6 digits of precision.'!

!FLOAT categoriesForClass!External-Data-Structured! !

!FLOAT methodsFor!

asFloat
	"Answer a <Float> of the same value as the receiver's contents."

	^(bytes floatAtOffset: 0)!

value
	"Answer the <Float> value of the receiver's 'value' field."

	^bytes floatAtOffset: _OffsetOf_value!

value: aFloat
	"Set the receiver's 'value' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_value put: aFloat! !

!FLOAT categoriesForMethods!
asFloat!converting!public! !
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!FLOAT class methodsFor!

defineFields
	"Define the fields of the FLOAT 'structure'.

		FLOAT  compileDefinition
	"

	self defineField: #value type: FLOATField new beOverride!

fileOutStem
	"Private - Answer standard file name stem for the class to file out on."

	^'FLOAT2'
!

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

!FLOAT class categoriesForMethods!
defineFields!public!template definition! !
fileOutStem!private!source filing! !
initialize!development!initializing!private! !
maximum!constants!public! !
minimum!constants!public! !
uninitialize!class hierarchy-removing!private! !
!

