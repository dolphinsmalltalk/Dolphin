"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Security.SecureHashAlgorithm'
	instanceVariableNames: 'context'
	classVariableNames: ''
	imports: #(#{OS.BCryptLibrary private})
	classInstanceVariableNames: ''
	classConstants: { 'StreamBlockSize' -> 16r4000 }!

Security.SecureHashAlgorithm guid: (Core.GUID fromString: '{44a4e77c-6645-42e0-bcc2-e8129d06655e}')!

Security.SecureHashAlgorithm comment: 'This class implements the Secure Hash Algorithm (SHA) described in the U.S. government''s Secure Hash Standard (SHS). 
This standard is described in FIPS PUB 180-1, "SECURE HASH STANDARD", April 17, 1995. The Secure Hash Algorithm is also described on p. 442 of ''Applied Cryptography: Protocols, Algorithms, and Source Code in C'' by Bruce Scheier, Wiley, 1996.'!

!Security.SecureHashAlgorithm categoriesForClass!Cryptography-Support! !

!Security.SecureHashAlgorithm methodsFor!

context
	"Private - Gets a SHA context"

	^context
		ifNil: 
			[self beFinalizable.
			context := OS.BCrypt createHash: BCRYPT_SHA1_ALG_HANDLE]!

finalHash
	"Private - Answers the final hash from the context and closes it"

	| hash |
	hash := ByteArray newFixed: 20.
	OS.BCrypt
		bCryptFinishHash: context
		pbOutput: hash
		cbOutput: 20
		dwFlags: 0.
	self resetContext.
	^LargeInteger fromBigEndianBytes: hash!

free
	self resetContext!

hashIn: aByteArray
	"Private - Hashes the data in aByteArray using the current SHA context"

	OS.BCrypt
		bCryptHashData: self context
		pbInput: aByteArray
		cbInput: aByteArray size
		dwFlags: 0!

hashInInteger: aPositiveInteger 
	"Hash in the given positive integer. The integer to be hashed should have 512 or fewer bits."

	| buffer dstIndex |
	aPositiveInteger digitLength * 8 <= 512 ifFalse: [self error: 'integer cannot exceed 512 bits'].
	buffer := ByteArray new: 64.
	dstIndex := 0.
	aPositiveInteger digitLength to: 1
		by: -1
		do: [:i | buffer at: (dstIndex := dstIndex + 1) put: (aPositiveInteger digitAt: i)].

	"process that one block"
	self hashIn: buffer!

hashInMessage: aByteObject
	"Hash in the given byte object message using the Secure Hash Algorithm. Note that if the argument is a string, then the resulting hash may vary depending on the encoding of the string because the binary representation may be different. To get a consistent hash value for strings you should ensure that the encoding is always either UTF-16, or UTF-8."

	^self hashIn: aByteObject
!

hashInStream: aPositionableStream
	"Hash in the contents of the given stream from the current position to the end using the Secure Hash Algorithm. 
	The SHA algorithm is defined in FIPS PUB 180-1. It is also described on p. 442 of 'Applied Cryptography: Protocols, Algorithms, and Source Code in C' by Bruce Scheier, Wiley, 1996."

	[aPositionableStream atEnd]
		whileFalse: [self hashIn: (aPositionableStream basicNextAvailable: StreamBlockSize)]!

hashInteger: aPositiveInteger 
	"Hash the given positive integer. The integer to be hashed should have 512 or fewer bits. 
	This entry point is used in key generation."

	self resetContext.
	self hashInInteger: aPositiveInteger.
	^self finalHash!

hashMessage: aStringOrByteArray
	"Hash the given message using the Secure Hash Algorithm."

	self resetContext.
	self hashInMessage: aStringOrByteArray.
	^ self finalHash
!

hashStream: aPositionableStream 
	"Hash the contents of the given stream from the current position to the end using the Secure Hash Algorithm. 
	The SHA algorithm is defined in FIPS PUB 180-1. It is also described on p. 442 of 'Applied Cryptography: Protocols, Algorithms, and Source Code in C' by Bruce Scheier, Wiley, 1996.
	
	SecureHashAlgorithm new hashStream: (ReadStream on: 'foo')
	"

	self resetContext.
	self hashInStream: aPositionableStream.
	^self finalHash!

resetContext
	context ifNil: [^self].
	self beUnfinalizable.
	OS.BCrypt bCryptDestroyHash: context.
	context := nil! !

!Security.SecureHashAlgorithm categoriesForMethods!
context!helpers!private! !
finalHash!helpers!private! !
free!finalizing!public! !
hashIn:!helpers!private! !
hashInInteger:!operations!public! !
hashInMessage:!operations!public! !
hashInStream:!operations!public! !
hashInteger:!operations!public! !
hashMessage:!operations!public! !
hashStream:!operations!public! !
resetContext!helpers!private! !
!

!Security.SecureHashAlgorithm class methodsFor!

example
	"Here are the first two examples from the specification document (FIPS PUB 180-1).
	
	self example
	"

	| hash |
	hash := self new hashMessage: 'abc'.
	hash = 16rA9993E364706816ABA3E25717850C26C9CD0D89D ifFalse: [
		self error: 'Test #1 failed!!'].

	hash := self new hashMessage:
		'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq'.
	hash = 16r84983E441C3BD26EBAAE4AA1F95129E5E54670F1 ifFalse: [
		self error: 'Test #2 failed!!'].
	
	^true
!

example2
	"Here is the third example from the specification document (FIPS PUB 180-1). 
	This example may take several seconds.

	self example2
	"

	| hash |
	hash := self new hashMessage: ((String new: 1000000) collect: [:each | $a]).
	hash = 16r34AA973CD4C4DAA4F61EEB2BDBAD27316534016F ifFalse: [
		self error: 'Test #3 failed!!'].
	^true
! !

!Security.SecureHashAlgorithm class categoriesForMethods!
example!examples!public! !
example2!examples!public! !
!

