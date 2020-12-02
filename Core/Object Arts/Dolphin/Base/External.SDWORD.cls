"Filed out from Dolphin Smalltalk 7"!

DWORD subclass: #SDWORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SDWORD guid: (GUID fromString: '{87b4c5ab-026e-11d3-9fd7-00a0cc3e4a32}')!
SDWORD comment: '<SDWORD> is an <ExternalStructure> class to wrap the Win32 type of the same name.

SDWORD is used to represent signed 32-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	(-2**31) to: (2**31)-1
'!
!SDWORD categoriesForClass!External-Data-Structured! !
!SDWORD methodsFor!

isSigned
	"Answer whether the receiver holds a signed 2's complement binary value, as opposed to an unsigned binary value."

	^true!

unsignedValue: anUnsigned
	"Set the receiver's value field to the value of the unsigned positive
	integer, anUnsigned."

	bytes dwordAtOffset: 0 put: anUnsigned!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes sdwordAtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_value put: anInteger! !
!SDWORD categoriesFor: #isSigned!public!testing! !
!SDWORD categoriesFor: #unsignedValue:!accessing!public! !
!SDWORD categoriesFor: #value!**compiled accessors**!public! !
!SDWORD categoriesFor: #value:!**compiled accessors**!public! !

!SDWORD class methodsFor!

defineFields
	"Define the fields of the SDWORD external type.
		SDWORD compileDefinition
	"

	self defineField: #value
		type: ((SDWORDField new)
				beOverride;
				yourself)!

fromUnsignedInteger: anUnsignedInteger
	"Answer a new instance of the receiver with contents copied from anInteger"

	^self new unsignedValue: anUnsignedInteger!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil! !
!SDWORD class categoriesFor: #defineFields!public!template definition! !
!SDWORD class categoriesFor: #fromUnsignedInteger:!instance creation!public! !
!SDWORD class categoriesFor: #initialize!development!initializing!private! !
!SDWORD class categoriesFor: #uninitialize!class hierarchy-removing!private! !

