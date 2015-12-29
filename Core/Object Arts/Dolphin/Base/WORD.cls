"Filed out from Dolphin Smalltalk X6.1"!

ExternalInteger subclass: #WORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WORD guid: (GUID fromString: '{87B4C5AD-026E-11D3-9FD7-00A0CC3E4A32}')!
WORD comment: '<WORD> is an <ExternalStructure> class to wrap the Win32 type of the same name.

WORD is used to represent unsigned 16-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	0 to: (2**16)-1'!
!WORD categoriesForClass!External-Data-Structured! !
!WORD methodsFor!

asSignedInteger
	"Answer the signed 16-bit Integer value of the receiver."

	^bytes swordAtOffset: 0!

value
	"Answer the receiver's value field as a Smalltalk object."

	^bytes wordAtOffset: 0!

value: anObject 
	"Set the receiver's value field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject! !
!WORD categoriesFor: #asSignedInteger!converting!public! !
!WORD categoriesFor: #value!**compiled accessors**!public! !
!WORD categoriesFor: #value:!**compiled accessors**!public! !

!WORD class methodsFor!

fieldType
	"Private - Answer the <ExternalField> type to be used to represent the receiver's field type in 
	other structures."

	^WORDField!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil! !
!WORD class categoriesFor: #fieldType!constants!development!private! !
!WORD class categoriesFor: #initialize!development!initializing!private! !
!WORD class categoriesFor: #uninitialize!class hierarchy-removing!private! !

