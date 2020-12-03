"Filed out from Dolphin Smalltalk 7"!

External.WORD subclass: #'External.SWORD'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.SWORD guid: (Core.GUID fromString: '{87b4c5ac-026e-11d3-9fd7-00a0cc3e4a32}')!
External.SWORD comment: '<SWORD> is an <ExternalStructure> class to wrap the Win32 type of the same name.

SWORD is used to represent signed 16-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	(-2**15) to: (2**15)-1'!
!External.SWORD categoriesForClass!External-Data-Structured! !
!External.SWORD methodsFor!

isSigned
	"Answer whether the receiver holds a signed 2's complement binary value, as opposed to an unsigned binary value."

	^true!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes swordAtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes swordAtOffset: _OffsetOf_value put: anInteger! !
!External.SWORD categoriesFor: #isSigned!public!testing! !
!External.SWORD categoriesFor: #value!**compiled accessors**!public! !
!External.SWORD categoriesFor: #value:!**compiled accessors**!public! !

!External.SWORD class methodsFor!

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
!External.SWORD class categoriesFor: #defineFields!public!template definition! !
!External.SWORD class categoriesFor: #initialize!development!initializing!private! !
!External.SWORD class categoriesFor: #uninitialize!class hierarchy-removing!private! !

