"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Kernel.STBPrefix'
	instanceVariableNames: 'uint32'
	classVariableNames: 'DataPrefix ProxyPrefix'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'BytesMask' -> 16r10.
		'CharacterMask' -> 16r4.
		'ClassPrefixMask' -> 16r4.
		'DataPrefixMask' -> 16r2.
		'IndexShift' -> -16r4.
		'InstSizeMask' -> 16rFF.
		'InstSizeShift' -> -16r8.
		'LiteralPrefixMask' -> 16r8.
		'LocatorLenShift' -> -16r10.
		'MaxPredefinedRef' -> 16r18.
		'NonZeroVersionMask' -> 16r40.
		'ProxyMask' -> 16r8.
		'SmallIntegerMask' -> 16r1.
		'VariableMask' -> 16r20
	}!
Kernel.STBPrefix guid: (Core.GUID fromString: '{87b4c4c2-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.STBPrefix comment: 'STBPrefix represents the object prefix encoding used in an STB binary file stream. It encapsulates much of the complexity of the data encoding performed by the STBOutFiler and STBInFiler classes. As the data encoding has been designed to achieve a reasonably compact format there are some restrictions on the order in which the methods can be called.

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
!Kernel.STBPrefix categoriesForClass!System-Binary storage! !
!Kernel.STBPrefix methodsFor!

character
	"Answer the Character represented by the receiver."

	^Character value: (uint32 bitShift: IndexShift)!

encodeClass: aClass locator: aString
	"Answer a 32-bit <integer> STB prefix code for an object of a hitherto unencountered class
	aClass, with locator, aString."

	| code |
	code := uint32
				bitOr: (ClassPrefixMask bitOr: ((aString size bitShift: 16) bitOr: (aClass instSize bitShift: 8))).
	aClass isVariable
		ifTrue: 
			[code := code bitOr: (aClass isBytes ifTrue: [##(BytesMask | VariableMask)] ifFalse: [VariableMask])].
	aClass stbVersion ~~ 0 ifTrue: [code := code bitOr: NonZeroVersionMask].
	^code!

encodeClassRef: anInteger
	"Answer a 32-bit <integer> STB prefix code for a hitherto unencountered object whose class
	has already been output with reference index, anInteger. As we encode the class reference
	within the prefix code the object data immediately follows it."

	^uint32 bitOr: (anInteger bitShift: 4)!

instSize
	"Answer the receiver's instSize field."

	^(uint32 bitShift: InstSizeShift) bitAnd: InstSizeMask!

isBytes
	"Answer the Boolean value of the isBytes bit flag."

	^uint32 allMask: BytesMask!

isCharacter
	"Answer whether the receiver represents a Character."

	^uint32 anyMask: CharacterMask!

isClassPrefix
	"Answer the Boolean value of the isClassPrefix bit flag."

	^uint32 anyMask: ClassPrefixMask!

isDataPrefix
	"Answer the Boolean value of the isDataPrefix bit flag."

	^uint32 anyMask: DataPrefixMask!

isNonZeroVersion
	"Answer the Boolean value of the isNonZeroVersion bit flag."

	^uint32 anyMask: NonZeroVersionMask!

isProxy
	"Answer the Boolean value of the isProxy bit flag.
	If true, the object that the receiver prefixes is
	a proxy for the object rather than the object itself."

	^uint32 anyMask: ProxyMask!

isSmallInteger
	"Answer the Boolean value of the isSmallInteger bit flag."

	^uint32 anyMask: 1!

isVariable
	"Answer the Boolean value of the isVariable bit flag."

	^uint32 allMask: VariableMask!

printOn: aStream
	"Append a debugging description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(.
	uint32 printOn: aStream base: 16 showRadix: true.
	aStream nextPutAll: ': '.
	self isSmallInteger ifTrue: [
		aStream print: self smallInteger]
	ifFalse: [ self isDataPrefix ifFalse: [
		self isCharacter
			 ifTrue: [aStream print: self character]
			ifFalse: [aStream nextPutAll: 'object ref: '; print: self refIndex]]
	ifTrue: [
		aStream nextPutAll: 'class'.
		self isClassPrefix
			ifTrue: [aStream nextPutAll: ' object']
			ifFalse: [aStream nextPutAll: ' ref: '; print: self refIndex]]].
	aStream nextPut: $)!

refIndex
	"Answer the receiver's object or class reference index."

	^uint32 bitShift: IndexShift!

smallInteger
	"Answer the receiver decoded into a SmallInteger."

	^uint32 bitShift: -1!

uint32
	"Answer the receiver encoded as a 32-bit unsigned integer."

	^uint32
!

uint32: anInteger
	"Set the receiver's dword inst var to anInteger.
	Answer the receiver."

	uint32 := anInteger.
	^self! !
!Kernel.STBPrefix categoriesForMethods!
character!accessing!public! !
encodeClass:locator:!accessing!public! !
encodeClassRef:!accessing!public! !
instSize!accessing!public! !
isBytes!public!testing! !
isCharacter!public!testing! !
isClassPrefix!public!testing! !
isDataPrefix!public!testing! !
isNonZeroVersion!public!testing! !
isProxy!public!testing! !
isSmallInteger!public!testing! !
isVariable!public!testing! !
printOn:!development!printing!public! !
refIndex!accessing!public! !
smallInteger!accessing!public! !
uint32!accessing!public! !
uint32:!accessing!public! !
!

!Kernel.STBPrefix class methodsFor!

encodeCharacter: aCharacter
	^(aCharacter codePoint bitShift: ##(IndexShift negated)) bitOr: CharacterMask!

encodeObjectRef: anInteger
	^anInteger bitShift: 4!

encodeSmallInteger: aSmallInteger
	^(aSmallInteger bitShift: 1) bitOr: 1!

forData
	"Answer an immutable instance carrying the basic encoding to prefix a data object."

	^DataPrefix!

forProxy
	"Answer an immutable instance carrying the basic encoding to prefix a proxy object."

	^ProxyPrefix!

fromInteger: anInteger
	"Answer a new instance initialised from the 32-bit <integer> STB prefix code, anInteger."

	^self new
		uint32: anInteger!

initialize
	DataPrefix := (self fromInteger: DataPrefixMask)
				isImmutable: true;
				yourself.
	ProxyPrefix := (self fromInteger: DataPrefixMask | ProxyMask)
				isImmutable: true;
				yourself!

uninitialize
	DataPrefix := ProxyPrefix := nil! !
!Kernel.STBPrefix class categoriesForMethods!
encodeCharacter:!operations!public! !
encodeObjectRef:!operations!public! !
encodeSmallInteger:!operations!public! !
forData!instance creation!public! !
forProxy!instance creation!public! !
fromInteger:!instance creation!public! !
initialize!development!initializing!public! !
uninitialize!class hierarchy-removing!private! !
!

