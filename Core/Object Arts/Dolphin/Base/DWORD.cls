"Filed out from Dolphin Smalltalk 7"!

ExternalInteger subclass: #DWORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DWORD guid: (GUID fromString: '{87b4c5aa-026e-11d3-9fd7-00a0cc3e4a32}')!
DWORD comment: '<DWORD> is an <ExternalStructure> class to wrap the Win32 type of the same name.

DWORD is used to represent unsigned 32-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	0 to: (2**32)-1'!
!DWORD categoriesForClass!External-Data-Unstructured! !
!DWORD methodsFor!

asSignedInteger
	"Answer the signed 32-bit <Integer> value of the receiver."

	^bytes sdwordAtOffset: 0!

asUnsignedInteger
	"Answer the unsigned 32-bit <Integer> value of the receiver."

	^bytes dwordAtOffset: 0!

highSWord
	"Answer the high-order signed word of the receiver. Assumes little-endian
	ordering."

	^bytes swordAtOffset: 2!

highSWord: anInteger
	"Set the high-order signed word of the receiver. Assumes little-endian
	ordering. Answer the receiver."

	bytes swordAtOffset: 2 put: anInteger!

highWord
	"Answer the high-order word of the receiver. Assumes little-endian
	ordering."

	^bytes wordAtOffset: 2!

highWord: anInteger
	"Set the high-order word of the receiver. Assumes little-endian
	ordering. Answer the receiver."

	bytes wordAtOffset: 2 put: anInteger!

lowSWord
	"Answer the low-order signed word of the receiver. Assumes little-endian
	ordering."

	^bytes swordAtOffset: 0!

lowSWord: anInteger
	"Answer the low-order signed word of the receiver. Assumes little-endian
	ordering. Answer the receiver."

	bytes swordAtOffset: 0 put: anInteger!

lowWord
	"Answer the low-order word of the receiver. Assumes little-endian
	ordering."

	^bytes wordAtOffset: 0!

lowWord: anInteger
	"Answer the low-order word of the receiver. Assumes little-endian
	ordering. Answer the receiver."

	bytes wordAtOffset: 0 put: anInteger!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes dwordAtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_value put: anInteger! !
!DWORD categoriesFor: #asSignedInteger!converting!public! !
!DWORD categoriesFor: #asUnsignedInteger!converting!public! !
!DWORD categoriesFor: #highSWord!accessing!public! !
!DWORD categoriesFor: #highSWord:!accessing!public! !
!DWORD categoriesFor: #highWord!accessing!public! !
!DWORD categoriesFor: #highWord:!accessing!public! !
!DWORD categoriesFor: #lowSWord!accessing!public! !
!DWORD categoriesFor: #lowSWord:!accessing!public! !
!DWORD categoriesFor: #lowWord!accessing!public! !
!DWORD categoriesFor: #lowWord:!accessing!public! !
!DWORD categoriesFor: #value!**compiled accessors**!public! !
!DWORD categoriesFor: #value:!**compiled accessors**!public! !

!DWORD class methodsFor!

defineFields
	"Define the fields of the ExternalInteger 'structure'. ExternalInteger subclasses
	have a single value."

	self defineField: #value type: DWORDField new beOverride!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil! !
!DWORD class categoriesFor: #defineFields!public!template definition! !
!DWORD class categoriesFor: #initialize!development!initializing!private! !
!DWORD class categoriesFor: #uninitialize!class hierarchy-removing!private! !

