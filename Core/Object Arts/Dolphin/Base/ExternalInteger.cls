"Filed out from Dolphin Smalltalk X6.1"!

ExternalStructure subclass: #ExternalInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalInteger guid: (GUID fromString: '{87B4C594-026E-11D3-9FD7-00A0CC3E4A32}')!
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
!ExternalInteger categoriesForClass!External-Data-Structured! !
!ExternalInteger methodsFor!

= anObject
	"Answer whether the receiver is equivalent to anObject."

	^anObject = self value!

asInteger
	"Answer the Integer value of the receiver, signed or
	unsigned depending on the subclass"

	^self value!

asSignedInteger
	"Answer the signed 32-bit Integer value of the receiver.
	This can be useful where functions return values declared as unsigned, but with signed
	values in them (a typical C programmers' trick for notifying error conditions).
	Implementation Note: This should really be a subclass responsibility,
	but this saves some space."

	^self value!

asUIntPtr
	"Answer the receiver in a form suitable for passing/returning as a Windows LRESULT
	(32 or 64-bit, depending on host OS) return value. The default is self (which will cause the
	default window proc. of the window to be called for most objects other than Integers when
	used as a return value)."

	^self value!

asUnsignedInteger
	"Answer the unsigned Integer value of the receiver.
	This can be useful where unsigned values are stored in signed values.
	Implementation Note: This should really be a subclass responsibility,
	but this saves some space."

	^self value!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	self value displayOn: aStream!

hash
	"Answer the SmallInteger hash value for the receiver."

	^self value hash!

isNull
	"Answer whether the receiver is Null (i.e. equal to 0). 
	This message is useful way of testing for NULL pointers or handles."

	^super isNull or: [self value == 0]!

printOn: aStream
	"Append a textual representation of the receiver to aStream."

	| hex |
	hex := self isNull
			ifTrue: ['0']
			ifFalse: [self value printStringRadix: 16].
	aStream
		basicPrint: self;
		nextPut: $(; display: hex; nextPut: $)!

value
	"Answer the receiver's value as a Smalltalk <Integer>.
	Note: All subclasses defining this as a structure member named #value
	must mark that field as an override (send it #beOverride) as otherwise
	the necessary accessor will not be generated."

	^self subclassResponsibility!

value: anObject
	"Set the receiver's value field to the value of anObject."

	^self subclassResponsibility! !
!ExternalInteger categoriesFor: #=!comparing!public! !
!ExternalInteger categoriesFor: #asInteger!converting!public! !
!ExternalInteger categoriesFor: #asSignedInteger!converting!public! !
!ExternalInteger categoriesFor: #asUIntPtr!converting!public! !
!ExternalInteger categoriesFor: #asUnsignedInteger!converting!public! !
!ExternalInteger categoriesFor: #displayOn:!printing!public! !
!ExternalInteger categoriesFor: #hash!comparing!public! !
!ExternalInteger categoriesFor: #isNull!public!testing! !
!ExternalInteger categoriesFor: #printOn:!printing!public! !
!ExternalInteger categoriesFor: #value!converting!public! !
!ExternalInteger categoriesFor: #value:!**compiled accessors**!public! !

!ExternalInteger class methodsFor!

decompileDefinition
	"Don't allow the receiver and its subclasses to be decompiled since they are
	required by fundamental aspects of the system such as streaming"
	!

defineFields
	"Define the fields of the ExternalInteger 'structure'. ExternalInteger subclasses
	have a single value."

	self defineField: #value type: self fieldType new beOverride!

definesNewFields
	^self ~= ##(self) and: [self class includesSelector: #fieldType]!

defineTemplate
	"Initialize the receiver class' structure template."

	super defineTemplate.
	alignment := self elementSize!

fromInteger: anInteger
	"Answer a new instance of the receiver with contents copied from anInteger"

	^self new value: anInteger!

icon
	"Answer a suitable iconic representation for the receiver."

	^Integer icon! !
!ExternalInteger class categoriesFor: #decompileDefinition!development!public! !
!ExternalInteger class categoriesFor: #defineFields!initializing!public! !
!ExternalInteger class categoriesFor: #definesNewFields!private!testing! !
!ExternalInteger class categoriesFor: #defineTemplate!development!initializing!public! !
!ExternalInteger class categoriesFor: #fromInteger:!instance creation!public! !
!ExternalInteger class categoriesFor: #icon!constants!public! !

