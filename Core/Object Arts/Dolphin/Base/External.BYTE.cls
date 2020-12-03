"Filed out from Dolphin Smalltalk 7"!

External.INTEGER subclass: #'External.BYTE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.BYTE guid: (Core.GUID fromString: '{87b4c5a9-026e-11d3-9fd7-00a0cc3e4a32}')!
External.BYTE comment: '<BYTE> is an <ExternalStructure> class to wrap the Win32 type of the same name.

BYTE is used to represent unsigned 8-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	0 to: (2**8)-1	(i.e. 0 to: 255).'!
!External.BYTE categoriesForClass!External-Data-Unstructured! !
!External.BYTE methodsFor!

asSignedInteger
	"Answer the signed 8-bit <Integer> value of the receiver."

	^bytes sbyteAtOffset: 0!

asUnsignedInteger
	"Answer the unsigned 8-bit <Integer> value of the receiver."

	^bytes byteAtOffset: 0!

unsignedValue: anInteger
	"Set the receiver's value field to the value of the unsigned positive integer argument."

	bytes byteAtOffset: 0 put: anInteger!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes byteAtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_value put: anInteger! !
!External.BYTE categoriesFor: #asSignedInteger!converting!public! !
!External.BYTE categoriesFor: #asUnsignedInteger!converting!public! !
!External.BYTE categoriesFor: #unsignedValue:!accessing!public! !
!External.BYTE categoriesFor: #value!**compiled accessors**!public! !
!External.BYTE categoriesFor: #value:!**compiled accessors**!public! !

!External.BYTE class methodsFor!

defineFields
	"Define the fields of the ExternalInteger 'structure'. ExternalInteger subclasses
	have a single value."

	self defineField: #value type: BYTEField new beOverride!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil! !
!External.BYTE class categoriesFor: #defineFields!public!template definition! !
!External.BYTE class categoriesFor: #initialize!development!initializing!private! !
!External.BYTE class categoriesFor: #uninitialize!class hierarchy-removing!private! !

