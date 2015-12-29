"Filed out from Dolphin Smalltalk X6.1"!

ExternalInteger subclass: #BYTE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BYTE guid: (GUID fromString: '{87B4C5A9-026E-11D3-9FD7-00A0CC3E4A32}')!
BYTE comment: '<BYTE> is an <ExternalStructure> class to wrap the Win32 type of the same name.

BYTE is used to represent unsigned 8-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	0 to: (2**8)-1	(i.e. 0 to: 255).'!
!BYTE categoriesForClass!External-Data-Structured! !
!BYTE methodsFor!

asSignedInteger
	"Answer the signed 8-bit Integer value of the receiver."

	^bytes sbyteAtOffset: 0!

value
	"Answer the receiver's value field as a Smalltalk object."

	^bytes byteAtOffset: 0!

value: anObject 
	"Set the receiver's value field to the value of anObject."

	bytes byteAtOffset: 0 put: anObject! !
!BYTE categoriesFor: #asSignedInteger!converting!public! !
!BYTE categoriesFor: #value!**compiled accessors**!public! !
!BYTE categoriesFor: #value:!**compiled accessors**!public! !

!BYTE class methodsFor!

fieldType
	"Private - Answer the <ExternalField> type to be used to represent the receiver's field type in other
	structures."

	^BYTEField!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil! !
!BYTE class categoriesFor: #fieldType!constants!development!private! !
!BYTE class categoriesFor: #initialize!development!initializing!private! !
!BYTE class categoriesFor: #uninitialize!class hierarchy-removing!private! !

