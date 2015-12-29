"Filed out from Dolphin Smalltalk X6"!

Object subclass: #STBPrefix
	instanceVariableNames: 'dword'
	classVariableNames: ''
	poolDictionaries: 'STBPrefixConstants'
	classInstanceVariableNames: ''!
STBPrefix guid: (GUID fromString: '{87B4C4C2-026E-11D3-9FD7-00A0CC3E4A32}')!
STBPrefix comment: 'STBPrefix represents the object prefix encoding used in an STB binary file stream. It encapsulates much of the complexity of the data encoding performed by the STBOutFiler and STBInFiler classes. As the data encoding has been designed to achieve a reasonably compact format there are some restrictions on the order in which the methods can be called.

Instance Variables:

	dword		The actual 32-bit <Integer> encoding

Pools:
	STBPrefixConstants	<PoolConstantsDictionary> containing bit masks for testing the encoding.


The encodings are as follows (this is best viewed in a non-proportional font):

	SSSSSSSS SSSSSSSS SSSSSSSS SSSSSS11    a SmallInteger
	RRRRRRRR RRRRRRRR RRRRRRRR RRRR0000    an Object Reference
	RRRRRRRR RRRRRRRR RRRRRRRR RRRR0010    a Class Reference (Non-proxy object)
	???????? ????CCCC CCCCCCCC CCCC0100    a Character
	LLLLLLLL LLLLLLLL IIIIIIII ?NVB0110    an Initial Class prefix (to Non-proxy object)
	???????? ???????? ???????? ????1000    a Literal Object (STL filters only)
	RRRRRRRR RRRRRRRR RRRRRRRR RRRR1010    a Class Reference (Proxy object)
	???????? ???????? ???????? ????1100    RESERVED
	LLLLLLLL LLLLLLLL IIIIIIII ?NVB1110    an Initial Class prefix (to Proxy object)
	                            |||||||
	                            |||||| --> isSmallInteger
	                            ||||| ---> isDataPrefix
	                            |||| ----> isClassPrefix
	                            ||| -----> isProxy
	                            || ------> isBytes
	                            | -------> isVariable
	                             --------> isNonZeroVersion

	0SSSSSSS SSSSSSSS SSSSSSSS SSSSSSS1 -> 30 bit SmallInteger value (low bit always 1)
	00000000 00000000 CCCCCCCC CCCCCCCC -> 16 bit Charater value
	0000RRRR RRRRRRRR RRRRRRRR RRRRRRRR -> 28 bit Reference index
	00000000 00000000 LLLLLLLL LLLLLLLL -> 16 bit Class name length
	00000000 00000000 00000000 IIIIIIII -> 8 bit Instance size

When testing an instance of this class the tests should be performed in the following order.

	anSTBPrefix isLiteral
		ifTrue: [^the data for the literal follows in the stream].
	anSTBPrefix isSmallInteger
		ifTrue: [^anSTBPrefix smallInteger. to yeild the SmallInteger represented.]
		ifFalse: [
			anSTBPrefix isDataPrefix
				ifFalse: [
					anSTBPrefix isCharacter
						ifTrue: [^anSTBPrefix character]
						ifFalse: [^anSTBPrefix refIndex. to answer the index of an already loaded object.]]
				ifTrue: [
					The data of the object represented will follow the prefix (although perhaps not immediately).
					anSTBPrefix isClassPrefix
						ifFalse: [
							anSTBPrefix refIndex. is the index of the class of the object represented.
							The data of the object represented follows the prefix.]
						ifTrue: [
							anSTBPrefix isNonZeroVersion
								ifTrue: [The integer following the prefix is the version of the class of the object represented].
							anSTBPrefix classLocatorLen. is the number of following bytes containing the name
								of the class of the object represented.
							anSTBPrefix instSize. This is the instance size of the class of the object represented.
							anSTBPrefix isBytes
								ifTrue: [The class of the object represented is made of bytes].
							anSTBPrefix isVariable
								ifTrue: [The class of the object represented is indexable]].
					anSTBPrefix isProxy
						ifTrue: [
							The object represented is a proxy for the real one and should be sent a #fixup:at: message
							to yeild the real object]]]."'!
!STBPrefix categoriesForClass!System-Binary storage! !
!STBPrefix methodsFor!

beDataPrefix
	"Set the receiver's isDataPrefix bit flag."

	dword := dword bitOr: DataPrefixMask!

beLiteralPrefix
	"Set the receiver's isLiteralPrefix bit flag."

	dword := dword bitOr: LiteralPrefixMask!

beProxy
	"Set the receiver's isProxy bit flag."

	dword := dword bitOr: ProxyMask!

character
	"Answer the Character represented by the receiver."

	^Character value: (dword bitShift: IndexShift)!

character: aCharacter
	"Make the receiver a prefix to a 'virtual' Character, virtual because
	as we encode aCharacter's value entirely within the prefix no object data need follow."

	dword := (aCharacter asInteger bitShift: IndexShift negated) bitOr: CharacterMask!

class: aClass locator: aString
	"Make the receiver a prefix for an object of a hitherto unencountered class
	aClass with locator aString."

	dword := (dword bitOr: (
			ClassPrefixMask bitOr: (
				(aString size bitShift: 16) bitOr: 
					(aClass instSize bitShift: 8)))).
	aClass isBytes
		ifTrue: [dword := dword bitOr: BytesMask].
	aClass isVariable
		ifTrue: [dword := dword bitOr: VariableMask].
	aClass stbVersion ~= 0
		ifTrue: [dword := dword bitOr: NonZeroVersionMask].!

classLocatorLen
	"Answer the receiver's classLocatorLen field."

	^dword bitShift: -16.!

classRef: anInteger
	"The receiver will prefix a hitherto unencountered object whose class
	has already been output with reference index anInteger.
	As we encode the class reference within the prefix the object data
	immediately follows it."

	dword := dword bitOr: (anInteger bitShift: 4)!

dword
	"Answer the receiver as a 4 byte DWORD."

	^dword
!

dword: anInteger
	"Set the receiver's dword inst var to anInteger.
	Answer the receiver."

	dword := anInteger.
	^self!

instSize
	"Answer the receiver's instSize field."

	^(dword bitShift: InstSizeShift) bitAnd: InstSizeMask!

isBytes
	"Answer the Boolean value of the isBytes bit flag."

	^dword allMask: BytesMask!

isCharacter
	"Answer whether the receiver represents a Character."

	^dword anyMask: CharacterMask!

isClassPrefix
	"Answer the Boolean value of the isClassPrefix bit flag."

	^dword anyMask: ClassPrefixMask!

isDataPrefix
	"Answer the Boolean value of the isDataPrefix bit flag."

	^dword anyMask: DataPrefixMask!

isLiteralPrefix
	"Answer the Boolean value of the isLiteralPrefix bit flag."

	^dword anyMask: LiteralPrefixMask!

isNonZeroVersion
	"Answer the Boolean value of the isNonZeroVersion bit flag."

	^dword anyMask: NonZeroVersionMask!

isProxy
	"Answer the Boolean value of the isProxy bit flag.
	If true, the object that the receiver prefixes is
	a proxy for the object rather than the object itself."

	^dword anyMask: ProxyMask!

isSmallInteger
	"Answer the Boolean value of the isSmallInteger bit flag."

	^dword anyMask: 1!

isVariable
	"Answer the Boolean value of the isVariable bit flag."

	^dword allMask: VariableMask!

objectRef: anInteger
	"Make the receiver a prefix to a 'virtual' object that has already been
	output with index anInteger, virtual because as we encode the reference
	entirely within the prefix no object data need follow."

	dword := anInteger bitShift: 4!

printOn: aStream
	"Append a debugging description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(.
	dword printOn: aStream base: 16 showRadix: true.
	aStream nextPutAll: ': '.
	self isSmallInteger ifTrue: [
		aStream print: self smallInteger]
	ifFalse: [ self isDataPrefix ifFalse: [
		self isCharacter
			 ifTrue: [aStream print: self character]
			ifFalse: [aStream nextPut: 'object ref: '; print: self refIndex]]
	ifTrue: [
		aStream nextPutAll: 'class'.
		self isClassPrefix
			ifTrue: [aStream nextPutAll: ' object']
			ifFalse: [aStream nextPutAll: ' ref: '; print: self refIndex]]].
	aStream nextPut: $)!

refIndex
	"Answer the receiver's object or class reference index."

	^dword bitShift: IndexShift!

smallInteger
	"Answer the receiver decoded into a SmallInteger."

	^dword bitShift: -1!

smallInteger: aSmallInteger
	"Make the receiver a prefix to a 'virtual' SmallInteger, virtual because
	as we encode the integer entirely within the prefix no object data need follow."

	dword := (aSmallInteger bitShift: 1) bitOr: 1! !
!STBPrefix categoriesFor: #beDataPrefix!accessing!public! !
!STBPrefix categoriesFor: #beLiteralPrefix!accessing!public! !
!STBPrefix categoriesFor: #beProxy!accessing!public! !
!STBPrefix categoriesFor: #character!accessing!public! !
!STBPrefix categoriesFor: #character:!accessing!public! !
!STBPrefix categoriesFor: #class:locator:!accessing!public! !
!STBPrefix categoriesFor: #classLocatorLen!accessing!public! !
!STBPrefix categoriesFor: #classRef:!accessing!public! !
!STBPrefix categoriesFor: #dword!accessing!public! !
!STBPrefix categoriesFor: #dword:!accessing!public! !
!STBPrefix categoriesFor: #instSize!accessing!public! !
!STBPrefix categoriesFor: #isBytes!public!testing! !
!STBPrefix categoriesFor: #isCharacter!public!testing! !
!STBPrefix categoriesFor: #isClassPrefix!public!testing! !
!STBPrefix categoriesFor: #isDataPrefix!public!testing! !
!STBPrefix categoriesFor: #isLiteralPrefix!public!testing! !
!STBPrefix categoriesFor: #isNonZeroVersion!public!testing! !
!STBPrefix categoriesFor: #isProxy!public!testing! !
!STBPrefix categoriesFor: #isSmallInteger!public!testing! !
!STBPrefix categoriesFor: #isVariable!public!testing! !
!STBPrefix categoriesFor: #objectRef:!accessing!public! !
!STBPrefix categoriesFor: #printOn:!development!printing!public! !
!STBPrefix categoriesFor: #refIndex!accessing!public! !
!STBPrefix categoriesFor: #smallInteger!accessing!public! !
!STBPrefix categoriesFor: #smallInteger:!accessing!public! !

!STBPrefix class methodsFor!

forCharacter: aCharacter
	"Answer a new instance to prefix aCharacter."

	^self new
		character: aCharacter;
		yourself!

forData
	"Answer a newly initialised instance to prefix a data object."

	^self fromInteger: DataPrefixMask!

forLiteral
	"Answer a newly initialised instance to prefix a literal object."

	^self fromInteger: LiteralPrefixMask !

forObjectRef: anInteger
	"Answer a new instance to prefix an object that has already been output."

	^self new
		objectRef: anInteger;
		yourself!

forProxy
	"Answer a newly initialised instance to prefix a proxy object."

	^self forData
		beProxy;
		yourself!

forSmallInteger: aSmallInteger
	"Answer a new instance to prefix aSmallInteger."

	^self new
		smallInteger: aSmallInteger;
		yourself!

fromInteger: anInteger
	"Answer a new instance initialise from anInteger."

	^self new
		dword: anInteger! !
!STBPrefix class categoriesFor: #forCharacter:!instance creation!public! !
!STBPrefix class categoriesFor: #forData!instance creation!public! !
!STBPrefix class categoriesFor: #forLiteral!instance creation!public! !
!STBPrefix class categoriesFor: #forObjectRef:!instance creation!public! !
!STBPrefix class categoriesFor: #forProxy!instance creation!public! !
!STBPrefix class categoriesFor: #forSmallInteger:!instance creation!public! !
!STBPrefix class categoriesFor: #fromInteger:!instance creation!public! !

