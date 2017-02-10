"Filed out from Dolphin Smalltalk 7"!

WORD subclass: #SWORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SWORD guid: (GUID fromString: '{87B4C5AC-026E-11D3-9FD7-00A0CC3E4A32}')!
SWORD comment: '<SWORD> is an <ExternalStructure> class to wrap the Win32 type of the same name.

SWORD is used to represent signed 16-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	(-2**15) to: (2**15)-1'!
!SWORD categoriesForClass!External-Data-Structured! !
!SWORD methodsFor!

value
	"Answer the receiver's value field as a Smalltalk object."

	^bytes swordAtOffset: 0!

value: anObject 
	"Set the receiver's value field to the value of anObject."

	bytes swordAtOffset: 0 put: anObject! !
!SWORD categoriesFor: #value!**compiled accessors**!public! !
!SWORD categoriesFor: #value:!**compiled accessors**!public! !

!SWORD class methodsFor!

fieldType
	"Private - Answer the <ExternalField> type to be used to represent the receiver's field type in 
	other structures."

	^SWORDField!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil! !
!SWORD class categoriesFor: #fieldType!constants!development!private! !
!SWORD class categoriesFor: #initialize!development!initializing!private! !
!SWORD class categoriesFor: #uninitialize!class hierarchy-removing!private! !

