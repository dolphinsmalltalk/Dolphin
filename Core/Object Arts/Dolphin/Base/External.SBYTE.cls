"Filed out from Dolphin Smalltalk 7"!

External.BYTE subclass: #'External.SBYTE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.SBYTE guid: (Core.GUID fromString: '{8f5bcc94-0245-4d91-a473-acc6bdb8f294}')!
External.SBYTE comment: '<SBYTE> is an <ExternalStructure> class to wrap the Win32 type of the same name.

SBYTE is used to represent signed 8-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	(-2**7) to: (2**7)-1	(i.e. -128 to: 127)
'!
!External.SBYTE categoriesForClass!External-Data-Structured! !
!External.SBYTE methodsFor!

isSigned
	"Answer whether the receiver holds a signed 2's complement binary value, as opposed to an unsigned binary value."

	^true!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes sbyteAtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes sbyteAtOffset: _OffsetOf_value put: anInteger! !
!External.SBYTE categoriesFor: #isSigned!public!testing! !
!External.SBYTE categoriesFor: #value!**compiled accessors**!public! !
!External.SBYTE categoriesFor: #value:!**compiled accessors**!public! !

!External.SBYTE class methodsFor!

defineFields
	"Define the fields of the ExternalInteger 'structure'. ExternalInteger subclasses
	have a single value."

	self defineField: #value type: SBYTEField new beOverride!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil! !
!External.SBYTE class categoriesFor: #defineFields!public!template definition! !
!External.SBYTE class categoriesFor: #initialize!development!initializing!private! !
!External.SBYTE class categoriesFor: #uninitialize!class hierarchy-removing!private! !

