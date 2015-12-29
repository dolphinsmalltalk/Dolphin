"Filed out from Dolphin Smalltalk X6.1"!

DWORD subclass: #SDWORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SDWORD guid: (GUID fromString: '{87B4C5AB-026E-11D3-9FD7-00A0CC3E4A32}')!
SDWORD comment: '<SDWORD> is an <ExternalStructure> class to wrap the Win32 type of the same name.

SDWORD is used to represent signed 32-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	(-2**31) to: (2**31)-1
'!
!SDWORD categoriesForClass!External-Data-Structured! !
!SDWORD methodsFor!

asUnsignedInteger
	"Answer the unsigned 32-bit Integer value of the receiver."

	^bytes dwordAtOffset: 0!

unsignedValue: anUnsigned
	"Set the receiver's value field to the value of the unsigned positive
	integer, anUnsigned."

	bytes dwordAtOffset: 0 put: anUnsigned!

value
	"Answer the receiver's value field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

value: anObject 
	"Set the receiver's value field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject! !
!SDWORD categoriesFor: #asUnsignedInteger!converting!public! !
!SDWORD categoriesFor: #unsignedValue:!accessing!public! !
!SDWORD categoriesFor: #value!**compiled accessors**!public! !
!SDWORD categoriesFor: #value:!**compiled accessors**!public! !

!SDWORD class methodsFor!

fieldType
	"Private - Answer the <ExternalField> type to be used to represent the receiver's field type in 
	other structures."

	^SDWORDField!

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
!SDWORD class categoriesFor: #fieldType!constants!development!private! !
!SDWORD class categoriesFor: #fromUnsignedInteger:!instance creation!public! !
!SDWORD class categoriesFor: #initialize!development!initializing!private! !
!SDWORD class categoriesFor: #uninitialize!class hierarchy-removing!private! !

