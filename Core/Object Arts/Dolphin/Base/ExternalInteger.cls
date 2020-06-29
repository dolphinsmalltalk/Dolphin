"Filed out from Dolphin Smalltalk 7"!

ExternalScalar subclass: #ExternalInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalInteger guid: (GUID fromString: '{87b4c594-026e-11d3-9fd7-00a0cc3e4a32}')!
ExternalInteger isAbstract: true!
ExternalInteger comment: 'ExternalInteger is an abstract class of ExternalStructures to represent machine native integer formats. Various subclasses are defined to represent the signed and unsigned forms with varying numbers of bits:

8-bit
	signed	SBYTE
	unsigned	BYTE
16-bit
	signed	SWORD
	unsigned	WORD
32-bit
	signed	SDWORD
	unsigned	DWORD
64-bit
	signed	LARGE_INTEGER
	unsigned	ULARGE_INTEGER
'!
!ExternalInteger categoriesForClass!External-Data-Unstructured! !
!ExternalInteger methodsFor!

asInteger
	"Answer the Integer value of the receiver, signed or
	unsigned depending on the subclass"

	^self value!

asSignedInteger
	"Answer the signed <Integer> value of the receiver."

	^self subclassResponsibility!

asString
	"Answer the String representation of the receiver."

	^self asInteger displayString!

asUIntPtr
	"Answer the receiver in a form suitable for passing/returning as a Windows LRESULT
	(32 or 64-bit, depending on host OS) return value. The default is self (which will cause the
	default window proc. of the window to be called for most objects other than Integers when
	used as a return value)."

	^self value!

asUnsignedInteger
	"Answer the unsigned <Integer> value of the receiver.
	This can be useful where unsigned values are stored in signed values."

	^self subclassResponsibility!

hash
	"Answer the SmallInteger hash value for the receiver."

	^self value hash!

isNull
	"Answer whether the receiver is Null (i.e. equal to 0). 
	This message is useful way of testing for NULL pointers or handles."

	^super isNull or: [self value == 0]!

isSigned
	"Answer whether the receiver holds a signed 2's complement binary value, as opposed to an unsigned binary value."

	^false! !
!ExternalInteger categoriesFor: #asInteger!converting!public! !
!ExternalInteger categoriesFor: #asSignedInteger!converting!public! !
!ExternalInteger categoriesFor: #asString!converting!public! !
!ExternalInteger categoriesFor: #asUIntPtr!converting!public! !
!ExternalInteger categoriesFor: #asUnsignedInteger!converting!public! !
!ExternalInteger categoriesFor: #hash!comparing!public! !
!ExternalInteger categoriesFor: #isNull!public!testing! !
!ExternalInteger categoriesFor: #isSigned!public!testing! !

!ExternalInteger class methodsFor!

defineTemplate
	"Initialize the receiver class' structure template."

	super defineTemplate.
	alignment := self elementSize!

fromInteger: anInteger
	"Answer a new instance of the receiver with contents copied from anInteger"

	^self new value: anInteger! !
!ExternalInteger class categoriesFor: #defineTemplate!public!template definition! !
!ExternalInteger class categoriesFor: #fromInteger:!instance creation!public! !

