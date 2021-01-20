"Filed out from Dolphin Smalltalk 7"!

SerialNumberProtector subclass: #ElgamalSerialNumberProtector
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ElgamalSerialNumberProtector guid: (GUID fromString: '{b2dbd9ad-5b79-4232-9179-bd91adbb1274}')!
ElgamalSerialNumberProtector comment: 'This class is an example of how to develop a replacement encryption policy for Product Protection serial numbers.  It shows how to plug in a replacement algorithm which uses private/public key encryption.  (The much faster and simpler PC1 cypher is still used for encrypting the method''s bytecodes, what this shows is a different way to protect the key used to unlock the methods.)

It uses the Elgamal asymmetric en/decryption  layered over DSA.  In practical terms that has some practical disadvantages.

One is that each time a serial number is issues it MUST be joined with a new "random" number to be encrypted, and the entire encryption depends on those numbers being genuinely unguessable.  Generating unguessable numbers on a computer is not easy.  Dolphin has a useful-but-by-no-means ideal generator, which is used by default, but if you are encrypting several serial numbers in a loop then you may very quickly use up the resevoir of available "randomness".

Secondly, the encrypted form is rather long -- an order of magnitude longer than the plaintext.  That makes it unsuitable for applications where the user is expected to type in a serial number to unlock an application.  One way around that problem is to use an unlock file instead of a string.  Your application could either read the contents of the file each time it started, or could copy the file''s contents into the Windows registry when it is first unlocked, and thereafter use the registry to find the data.
'!
!ElgamalSerialNumberProtector categoriesForClass!Unclassified! !
!ElgamalSerialNumberProtector methodsFor!

dataFromString: aString
	"Private - Answer the raw encrypted data contained in the human-readable String."

	^($/ split: aString) collect: [:each | self class integerFromReadableString: each]!

decrypt: anArrayOfLargeIntegers
	"Answer anArrayOfLargeIntegers decrypted according to the encryption policy the receiver represents.
	In this case using Elgamal encryption based on the DSA."

	| dsa |

	dsa := DigitalSignatureAlgorithm new.

	"NB: the Elgamal implementation is set up on the assumption
	that the 'public' will encode messages using the public key which
	only the recipent can decode using their private key.   We use it the
	other way around."
	^ dsa
		elgamalDecrypt: anArrayOfLargeIntegers
		privateKey: self key.
!

encrypt: anInteger
	"Answer anInteger encrypted according to the encryption policy the receiver represents.
	In this case using Elgamal encryption based on the DSA.
	The answer is actually an array of 2 integers."

	| dsa |

	dsa := DigitalSignatureAlgorithm new.
	dsa initRandomFromUser.					"<--- note expensive and potentially weak PRN generation"

	"NB: the Elgamal implementation is set up on the assumption
	that the 'public' will encode messages using the public key which
	only the recipent can decode using their private key.   We use it the
	other way around."
	^ dsa
		elgamalEncrypt: anInteger
		publicKey: self key.!

stringFromData: anArrayOfLargeIntegers
	"Private - Answer a human-readable String representing the given raw encrypted data."
	
	| stream |

	stream := String writeStream.
	anArrayOfLargeIntegers
		do: [:each | stream nextPutAll: (self class readableStringFromInteger: each)]
		separatedBy: [stream nextPutAll: '/'].
	^ stream contents.! !
!ElgamalSerialNumberProtector categoriesFor: #dataFromString:!helpers!private! !
!ElgamalSerialNumberProtector categoriesFor: #decrypt:!operations!public! !
!ElgamalSerialNumberProtector categoriesFor: #encrypt:!operations!public! !
!ElgamalSerialNumberProtector categoriesFor: #stringFromData:!helpers!public! !

