"Filed out from Dolphin Smalltalk"!

WORD subclass: #SWORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SWORD guid: (GUID fromString: '{87b4c5ac-026e-11d3-9fd7-00a0cc3e4a32}')!

SWORD comment: '<SWORD> is an <ExternalStructure> class to wrap the Win32 type of the same name.

SWORD is used to represent signed 16-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	(-2**15) to: (2**15)-1'!

!SWORD categoriesForClass!External-Data-Structured! !

!SWORD methodsFor!

isSigned
	"Answer whether the receiver holds a signed 2's complement binary value, as opposed to an unsigned binary value."

	^true!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes swordAtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes swordAtOffset: _OffsetOf_value put: anInteger! !

!SWORD categoriesForMethods!
isSigned!public!testing! !
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!SWORD class methodsFor!

defineFields
	"Define the fields of the ExternalInteger 'structure'. ExternalInteger subclasses
	have a single value."

	self defineField: #value type: SWORDField new beOverride!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil! !

!SWORD class categoriesForMethods!
defineFields!public!template definition! !
initialize!development!initializing!private! !
uninitialize!class hierarchy-removing!private! !
!

