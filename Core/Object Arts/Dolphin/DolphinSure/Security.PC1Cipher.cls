"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Security.PC1Cipher'
	instanceVariableNames: 'key box i j'
	classVariableNames: 'RandPool'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Security.PC1Cipher guid: (Core.GUID fromString: '{611b2a17-3b8e-4bd9-94e2-38ce0d22736c}')!
Security.PC1Cipher comment: 'This class provides a stream encoder/decoder using the PC1 algorithm.
Portions ©1997 by Stefan Matthias Aust'!
!Security.PC1Cipher categoriesForClass!Cryptography-Support! !
!Security.PC1Cipher methodsFor!

advance
	"Advance the state of the cypher stream by one step without actually
	encyphering anything.
	This cypher is known to have some slight weaknesses in the first few bytes
	that it emits (they reflect the initial state rather predictably) and this makes
	combinations of similar texts and similar keys rather fragile (in theory) for the
	first few iterations.  For that reason it's a good cautious move to 'advance'
	the cypher by a known (but, ideally, not too easily predictable) number of rounds
	before using it. Experts seem to think that anything over 255 (the nummber of
	boxes) is enough.
	Needless to say the encryption and decryption must agree
	on how many rounds to use."

	i := i + 1 bitAnd: 255.
	j := j + (box at: i + 1) bitAnd: 255.
	box swap: (i + 1) with: (j + 1).
!

advance: anInteger
	"Advance the state of the cypher stream the given number of steps without actually
	encyphering anything.  See the comment in #advance for why it you might want to do so."

	anInteger timesRepeat: [self advance].!

cipher: aByte
	"Cipher aByte (between 0 and 255). As PC1 is a symetric stream encoder, 
	the answer is either the encoded or decoded version."

	"deprecated because the name is dangerously misleading"
	Notification deprecated.

	"this method is too dangerous to exist, even with a deprecated note,
	without this check since this method will malfunction *silently* if passed
	any integer except a byte value"
	self assert: [aByte between: 0 and: 255].

	^ self cipherByte: aByte.!

cipherByte: aByte
	"Cipher aByte (between 0 and 255). As PC1 is a symetric stream encoder, 
	the answer is either the encoded or decoded version."

	self advance.
	^aByte bitXor: (box at: (((box at: i + 1) + (box at: j + 1)) bitAnd: 255) + 1).!

cipherBytes: aByteArray
	"Answer an encoded (or decoded) version of aByteArray."

	^aByteArray collect: [:each | self cipherByte: each].!

cipherString: aString
	"Answer an encoded (or decoded) version of aString."

	Notification deprecated.	"This doesn't work - Strings can't be treated as arbitrary arrays of bytes any longer"
	^aString collect: [:each | (self cipherByte: each asInteger) asCharacter]!

key
	"Answer the key of the receiver"

	^key
!

key: k
	"Private - Initialize box from k, a ByteArray of up to 256 bytes."

	key := k.	
	self reset.
!

postCopy
	box := box copy!

reset
	"Reset the state of the receiver"

	| n |
	box := (0 to: 255) asByteArray.
	j := 0.
	n := key size.
	0 to: 255
		do: 
			[:x | 
			j := (key at: x \\ n + 1) + (box at: x + 1) + j bitAnd: 255.
			box swap: x + 1 with: j + 1].
	i := j := 0! !
!Security.PC1Cipher categoriesFor: #advance!ciphering!public! !
!Security.PC1Cipher categoriesFor: #advance:!ciphering!public! !
!Security.PC1Cipher categoriesFor: #cipher:!ciphering!public! !
!Security.PC1Cipher categoriesFor: #cipherByte:!ciphering!public! !
!Security.PC1Cipher categoriesFor: #cipherBytes:!ciphering!public! !
!Security.PC1Cipher categoriesFor: #cipherString:!ciphering!public! !
!Security.PC1Cipher categoriesFor: #key!accessing!initializing!public! !
!Security.PC1Cipher categoriesFor: #key:!accessing!initializing!private! !
!Security.PC1Cipher categoriesFor: #postCopy!copying!public! !
!Security.PC1Cipher categoriesFor: #reset!accessing!initializing!public! !

!Security.PC1Cipher class methodsFor!

byteArrayFromInteger: aPositiveIntegerKey 
	| bytes n |
	bytes := OrderedCollection new: aPositiveIntegerKey byteSize.
	n := aPositiveIntegerKey.
	[n = 0] whileFalse: 
			[bytes add: (n bitAnd: 16rFF).
			n := n bitShift: -8].
	^bytes asByteArray!

churnRandPool
	"Private - Churn the random seed pool with a real world event."

	| sha |
	sha := SecureHashAlgorithm new.
	sha hashInInteger: self randPool.
	sha hashInInteger: Random systemClockSeed.
	^RandPool := sha finalHash!

example1
	"Encrypt a simple string.
		self example1
	"

	| encoder |
	encoder := self withStrength: 128.
	^encoder key -> (encoder cipherBytes: 'This is a 🐬 PC1 test' asByteArray)
!

example2
	"
		self example2
	"

	| encoder |
	encoder := self withKeyString: 'Dolphin'.
	^Utf8String fromByteArray: (encoder
				cipherBytes: #[37 96 247 218 229 49 17 103 94 64 244 105 11 180 138 185 67 97 61 196 101 126 196])!

generateRandomWithBits: bitSize
	"Answers a random <Integer> with the supplied bitSize. 
	The bitSize must be >=16 and will be rounded up to a multiple of 8.

	Applied Cryptography (Schneier) p427.

	(self generateRandomWithBits: 26) digitLength*8
	"

	| len random count sha |
	len := (bitSize + 7) // 8.
	self churnRandPool.
	count := self randPool \\ 16r3FFF.
	sha := SecureHashAlgorithm new.
	random := 0.
	[len > 0] whileTrue: 
			[| n |
			sha hashInInteger: self randPool.
			sha hashInInteger: count.
			n := len min: 16.
			random := (random bitShift: n * 8) bitOr: (sha finalHash bitAnd: (2 raisedToInteger: n * 8) - 1).
			count := count + 1.
			len := len - n].
	^random!

randPool
	"Private - Answer the 160 bit random pool seed generated from real world events.

	Applied Cryptography (Schneier) p427
	"

	RandPool
		ifNil: 
			[RandPool := 0.
			10 timesRepeat: [self churnRandPool]].
	^RandPool!

withKeyBytes: aKeyByteArray 
	"Answer an instance of the receiver with aKeyByteArray"

	^self new key: aKeyByteArray!

withKeyInteger: aPositiveIntegerKey 
	"Answer an instance of the receiver with aPositiveIntegerKey"

	^self withKeyBytes: (self byteArrayFromInteger: aPositiveIntegerKey)!

withKeyString: aKeyString
	"Answer an instance of the receiver with aKeyString"

	^self withKeyBytes: aKeyString asByteArray!

withStrength: bits 
	"Answer an instance of the receiver with <Integer> bits strength"

	^self withKeyInteger: (self generateRandomWithBits: bits)! !
!Security.PC1Cipher class categoriesFor: #byteArrayFromInteger:!helpers!private! !
!Security.PC1Cipher class categoriesFor: #churnRandPool!helpers!private! !
!Security.PC1Cipher class categoriesFor: #example1!examples!public! !
!Security.PC1Cipher class categoriesFor: #example2!examples!public! !
!Security.PC1Cipher class categoriesFor: #generateRandomWithBits:!helpers!public! !
!Security.PC1Cipher class categoriesFor: #randPool!helpers!private! !
!Security.PC1Cipher class categoriesFor: #withKeyBytes:!instance creation!public! !
!Security.PC1Cipher class categoriesFor: #withKeyInteger:!instance creation!public! !
!Security.PC1Cipher class categoriesFor: #withKeyString:!instance creation!public! !
!Security.PC1Cipher class categoriesFor: #withStrength:!instance creation!public! !

