"Filed out from Dolphin Smalltalk 7"!

BYTE subclass: #SBYTE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SBYTE guid: (GUID fromString: '{8F5BCC94-0245-4D91-A473-ACC6BDB8F294}')!
SBYTE comment: '<SBYTE> is an <ExternalStructure> class to wrap the Win32 type of the same name.

SBYTE is used to represent signed 8-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	(-2**7) to: (2**7)-1	(i.e. -128 to: 127)
'!
!SBYTE categoriesForClass!External-Data-Structured! !
!SBYTE methodsFor!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes sbyteAtOffset: 0!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes sbyteAtOffset: 0 put: anInteger! !
!SBYTE categoriesFor: #value!**compiled accessors**!public! !
!SBYTE categoriesFor: #value:!**compiled accessors**!public! !

!SBYTE class methodsFor!

fieldType
	"Private - Answer the <ExternalField> type to be used to represent the receiver's field type in 
	other structures."

	^SBYTEField!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil! !
!SBYTE class categoriesFor: #fieldType!constants!development!private! !
!SBYTE class categoriesFor: #initialize!development!initializing!private! !
!SBYTE class categoriesFor: #uninitialize!class hierarchy-removing!private! !

