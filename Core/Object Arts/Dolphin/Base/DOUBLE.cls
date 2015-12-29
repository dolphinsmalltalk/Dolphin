"Filed out from Dolphin Smalltalk X6.1"!

ExternalStructure subclass: #DOUBLE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DOUBLE guid: (GUID fromString: '{87B4C592-026E-11D3-9FD7-00A0CC3E4A32}')!
DOUBLE comment: 'DOUBLE is an <ExternalStructure> class to represent double precision (64-bit) floating point numbers in native format'!
!DOUBLE categoriesForClass!External-Data-Structured! !
!DOUBLE methodsFor!

asFloat
	"Answer a <Float> of the same value as the receiver's contents."

	^(bytes doubleAtOffset: 0)!

displayOn: target
	"Append a textual representation of the receiver onto the <puttableStream> argument,
	target, in the format that an end-user might want to see it."

	target display: (self isNull ifFalse: [self value])!

value
	"Answer the receiver's value field as a Smalltalk object."

	^bytes doubleAtOffset: 0!

value: anObject 
	"Set the receiver's value field to the value of anObject."

	bytes doubleAtOffset: 0 put: anObject! !
!DOUBLE categoriesFor: #asFloat!converting!public! !
!DOUBLE categoriesFor: #displayOn:!printing!private! !
!DOUBLE categoriesFor: #value!**compiled accessors**!public! !
!DOUBLE categoriesFor: #value:!**compiled accessors**!public! !

!DOUBLE class methodsFor!

defineFields
	"Define the fields of the DOUBLE 'structure'.

		DOUBLE compileDefinition
	"

	self defineField: #value type: DOUBLEField new!

fieldType
	"Private - Answer the <ExternalField> type to be used to represent the receiver's field type in 
	other structures."

	^DOUBLEField!

icon
	"Answer a suitable iconic representation for the receiver."

	^Float icon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil! !
!DOUBLE class categoriesFor: #defineFields!initializing!public! !
!DOUBLE class categoriesFor: #fieldType!constants!development!private! !
!DOUBLE class categoriesFor: #icon!constants!public! !
!DOUBLE class categoriesFor: #initialize!development!initializing!private! !
!DOUBLE class categoriesFor: #uninitialize!class hierarchy-removing!private! !

