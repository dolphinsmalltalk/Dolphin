"Filed out from Dolphin Smalltalk 7"!

Security.SerialNumberProtector subclass: #'Security.PC1SerialNumberProtector'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Security.PC1SerialNumberProtector guid: (Core.GUID fromString: '{5c339df7-5279-436b-87d2-09b67f105263}')!
Security.PC1SerialNumberProtector comment: 'A simple PC1-based implementation of encryption for Protected Product serial numbers.

It should be noted that, although PC1 is a fine cypher if used correctly, it is not really suitable for these purposes, and so -- although this is the default implementation -- it is not as strong as it could be.  This implementation mitigates the weakness to some extent by including a checksum with the encrypted data (as described below); however that is still vulnerable to a feasible, but difficult, brute-force attack.

Some background:

PC1 is a stream cypher, and like all stream cyphers, has the properly that it maps bytes (bits, actually) of the plaintext one-to-one onto bytes of cyphertext (and vice versa).  That means that it is possible for an attacker to damage parts of the message without preventing the rest from being read as normal (as long as they only replace bytes, not adding or removing any).  Unless the attacker can break the encryption, it is not possible to control the damaged plaintext, so it is not possible to replace parts of the message with choosen substitues, but it is possible to introduce garbage in choosen positions.

For example:

	If the plaintext is:
		abcedfrghi

	And the resulting PC1-encrypted cyphertext is:
		123456790

	Then an attacker changes two bytes:
		1UV4567890

	The resulting decoded text might be:
		a&%edfrghi

Most of the message is undamaged.

That has implications for use in Product Protection, which is why the checksum is necessary.  The serial number consists of a number of fields, the most important is the unlock key, which is adequately protected by PC1 since modifying that would make it stop working. The other fields (#productId, #expiry, #flags) are where the problem lies.  These are transformed by a simple and non-secure process into a sequence of bytes, and then encrypted.  Because the PC1 cypher is "separable" (as described above) that means that it would be possible to manipulate the extra fields without damaging the unlock key.  As a result it would require only ingenuity, rather than Nobel prize winning cryptographic expertise, to substitute garbage into those fields.  For one example, a hacker who wished to distribute a ''stolen'' serial number could generate new serial numbers (which appear to belong to random purchasers) by overwriting the ''product Id'' with garbage.

The actual implementation is stronger than that because it incldues a checksum (actually a SHA1 hash reduced to 40 bits by default) of the data.  That gives significant extra protection, but is not perfect because a brute-force search over 2**40 possible checksums is feasible on modern computers.

If you need protection against more than ingenuity and determination, then it would be advisable not to use the extra fields. A better solution would be to create a different subclass of SerialNumberProtector  encrypts the serial number in a way that scrambles all the bits together, so that changing any one will change the entire message, and so the attacker cannot change any part of the serial number without (almost certainly) invalidating it.  The ElgamalSerialNumberProtector illustrates how to develop and plug in a replacement encryption policy.'!
!Security.PC1SerialNumberProtector categoriesForClass!Unclassified! !
!Security.PC1SerialNumberProtector methodsFor!

checksumBits
	"Answer how many bits of checksum the reciever will include in encrypted data"

	^ 40.!

checksumFor: anInteger
	"Private - Answers a checksum of the given integer, the size (in bits) of the
	checksum is set from #checksumBits."

	| hash |
	hash := SecureHashAlgorithm new hashInteger: anInteger.

	"since SHA1 is supposed to be of crypto-quality hash, any
	bits are as 'random' as any other, so we just truncate the hash
	to the desired number of bits"
	^hash & ((1 << self checksumBits) - 1)!

cipher
	"Private - Answer an new PC1Cipher initialised with our key"

	^(PC1Cipher withKeyInteger: self key)
		advance: 255;
		yourself!

dataFromString: aString
	"Private - Answer the raw encrypted data contained in the human-readable String."

	^ self class integerFromReadableString: aString.!

decrypt: anInteger
	"Answer anInteger decrypted according to the encryption policy the receiver represents."

	| stream todo bytes data checksum answer |

	"uniquely convert integer to byte array, ignoring the leading byte since that was
	added as a dummy during encryption"
	stream := ByteArray writeStream.
	todo := anInteger.
	[todo > 255] whileTrue:
		[stream nextPut:( todo bitAnd: 16rFF).
		todo := todo bitShift: -8].
	bytes := stream contents reverse .

	"decypher"
	bytes :=  self cipher cipherBytes: bytes.

	"uniquely convert byte array to integer, we have to do it in reverse order
	because that's how we left them in #encrypt:"
	data := 0.
	bytes reverseDo: [:each | data := (data bitShift: 8) bitOr: each].

	"extract the checksum, and check it"
	checksum := data bitAnd: (1 << self checksumBits - 1).
	answer := data >> self checksumBits.
	(self checksumFor: answer) = checksum ifFalse: [^ nil].

	^ answer.!

encrypt: anInteger
	"Answer anInteger encrypted according to the encryption policy the receiver represents.
	The kind of object answered depends on the concrete subclass."

	| checksum data stream todo cipher bytes answer |

	"compute N-bit checksum and combine that with the input data"
	checksum := self checksumFor: anInteger.
	data := (anInteger << self checksumBits) bitOr: checksum.

	"uniquely convert integer to byte array"
	stream := ByteArray writeStream.
	todo := data.
	[todo > 0] whileTrue:
		[stream nextPut:( todo bitAnd: 16rFF).
		todo := todo bitShift: -8].
	bytes := stream contents.	"deliberately leave the results reversed"

	"encypher"
	cipher := self cipher.
	bytes :=  cipher cipherBytes: bytes.

	"uniquely convert byte array to integer, we must start with a lieading non-zero
	(which decryption will discard) or any leading zeros will be lost, and decryption will fail.
	In fact we start with a 'random' non-zero byte value just for a bit of variety"
	[(answer := cipher cipherByte: 0) = 0] whileTrue.
	bytes do: [:each | answer := (answer bitShift: 8) bitOr: each].

	^ answer.!

stringFromData: anInteger
	"Private - Answer a human-readable String representing the given raw encrypted data."
	
	^ self class readableStringFromInteger: anInteger.! !
!Security.PC1SerialNumberProtector categoriesFor: #checksumBits!constants!public! !
!Security.PC1SerialNumberProtector categoriesFor: #checksumFor:!helpers!private! !
!Security.PC1SerialNumberProtector categoriesFor: #cipher!helpers!private! !
!Security.PC1SerialNumberProtector categoriesFor: #dataFromString:!helpers!private! !
!Security.PC1SerialNumberProtector categoriesFor: #decrypt:!operations!public! !
!Security.PC1SerialNumberProtector categoriesFor: #encrypt:!operations!public! !
!Security.PC1SerialNumberProtector categoriesFor: #stringFromData:!helpers!public! !

