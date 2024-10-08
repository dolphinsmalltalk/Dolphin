﻿"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Security.SecureHashAlgorithm'
	instanceVariableNames: 'context'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Security.SecureHashAlgorithm guid: (Core.GUID fromString: '{44a4e77c-6645-42e0-bcc2-e8129d06655e}')!

Security.SecureHashAlgorithm comment: 'This class implements the Secure Hash Algorithm (SHA) described in the U.S. government''s Secure Hash Standard (SHS). 
This standard is described in FIPS PUB 180-1, "SECURE HASH STANDARD", April 17, 1995. The Secure Hash Algorithm is also described on p. 442 of ''Applied Cryptography: Protocols, Algorithms, and Source Code in C'' by Bruce Scheier, Wiley, 1996.'!

!Security.SecureHashAlgorithm categoriesForClass!Cryptography-Support! !

!Security.SecureHashAlgorithm methodsFor!

context
	"Private - Gets an SHA context"

	context isNil
		ifTrue: 
			[OS.Kernel32 isWindows7OrGreater
				ifFalse: [self error: 'Not supported on Vista and earlier versions of  Windows'].
			context := OS.BCrypt shaCreate].
	^context!

finalHash
	"Private - Answers the final hash from the context and closes it"

	| hashBytes hashValue |
	hashBytes := OS.BCrypt shaGetHash: self context.
	self resetContext.
	hashValue := 0.
	1 to: hashBytes size do: [:i | hashValue := (hashValue bitShift: 8) bitOr: (hashBytes at: i)].
	^hashValue!

hashIn: aByteArray
	"Private - Hashes the data in aByteArray using the current SHA context"

	OS.BCrypt shaHashBuffer: self context buffer: aByteArray!

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

hashInMessage: aStringOrByteArray
	"Hash in the given message using the Secure Hash Algorithm."

	^self hashInStream: (ReadStream on: aStringOrByteArray asByteArray)
!

hashInStream: aPositionableStream 
	"Hash in the contents of the given stream from the current position to the end using the Secure Hash Algorithm. 
	The SHA algorithm is defined in FIPS PUB 180-1. It is also described on p. 442 of 'Applied Cryptography: Protocols, 	Algorithms, and Source Code in C' by Bruce Scheier, Wiley, 1996.
	
	"

	[aPositionableStream atEnd] whileFalse: 
			[| buf |
			buf := aPositionableStream nextAvailable: 64.
			self hashIn: buf]!

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
	The SHA algorithm is defined in FIPS PUB 180-1. It is also described on p. 442 of 'Applied Cryptography: Protocols, 	Algorithms, and Source Code in C' by Bruce Scheier, Wiley, 1996.
	
	SecureHashAlgorithm new hashStream: (ReadStream on: 'foo')
	"

	self resetContext.
	self hashInStream: aPositionableStream.
	^self finalHash!

resetContext
	context notNil
		ifTrue: 
			[OS.BCrypt shaDestroy: context.
			context := nil]! !

!Security.SecureHashAlgorithm categoriesForMethods!
context!helpers!private! !
finalHash!helpers!private! !
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

