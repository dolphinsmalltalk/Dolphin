"Filed out from Dolphin Smalltalk 7"!

ProductProtector subclass: #PC1ProductProtector
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PC1ProductProtector guid: (GUID fromString: '{5cdc0f05-2865-415a-b78e-f13223e1192f}')!
PC1ProductProtector comment: 'One of these uses the PC1 cypher to encode/decode the bytecodes of all the methods that are to be protected.  Each method is encoded with a different instance of PC1Cipher which has been given a separate key derived from our secret key joined to the method''s name.'!
!PC1ProductProtector categoriesForClass!Unclassified! !
!PC1ProductProtector methodsFor!

cipherClass: aClass 
	"Private - Encrypts aClass using our key."

	self methodsOf: aClass do: [:m | self cipherMethod: m]!

cipherForMethod: aCompiledMethod 
	"Private - Answers a new PC1Cipher suitable for en/decrypting the given method."

	"Implementation notes:
	We combine the method's name with the key in order to peturb the PC1 cypher; PC1 should
	*never* be used for different plaintexts with the same key and ideally should not be used
	with 'similar' keys.
	We #advance: the cypher because PC1 is known to be weak in its first few bytes of output"

	| hashedKey |
	hashedKey := self hashKeyWith: aCompiledMethod displayString.
	^(PC1Cipher withKeyInteger: hashedKey)
		advance: 200;
		yourself!

cipherMethod: aCompiledMethod 
	"Private - Encrypts aCompiledMethod using our key."

	"Implementation note: we replace the bytecode array with an encrypted version.  Oddly
	this is not affected by the image stripper merging duplicate bytecodes  since if the result
	happens to be the same as the bytecode of any other method (encrypted or not, with
	the same or different key) the decryption process will naturally un-merge the duplication"

	| cipher |
	cipher := self cipherForMethod: aCompiledMethod.
	aCompiledMethod setByteCodes: (cipher cipherBytes: aCompiledMethod byteCodes)!

decipherClass: aClass 
	"Private - Encrypts aClass using our key."

	self methodsOf: aClass do: [:m | self decipherMethod: m]!

decipherMethod: aCompiledMethod 
	"Private - Decrypts aCompiledMethod using our key."

	| cipher |
	cipher := self cipherForMethod: aCompiledMethod.
	aCompiledMethod byteCodes: (cipher cipherBytes: aCompiledMethod byteCodes)!

decryptClasses: aCollection 
	"Decrypt the given classes using the key we have been configured to use."

	aCollection do: [:each | self decipherClass: each].!

encryptClasses: aCollection 
	"Encrypt the given classes using the key we have been configured to use."

	aCollection do: [:each | self cipherClass: each]!

hashKeyWith: aString
	"Private - Answers an Integer which is produced by hashing our key together with the given String."

	"Implementation note:
	The hash we use here is not required to be of cryptographic quality
	since all we want to do is ensure that the keys we use for PC1 are
	reasonably well scattered"

	^ self key * aString hash.!

methodsOf: aClass do: aBlockClosure 
	aClass methodDictionary do: [:each | each whileMutableDo: [aBlockClosure value: each]]! !
!PC1ProductProtector categoriesFor: #cipherClass:!operations!private! !
!PC1ProductProtector categoriesFor: #cipherForMethod:!helpers!private! !
!PC1ProductProtector categoriesFor: #cipherMethod:!operations!private! !
!PC1ProductProtector categoriesFor: #decipherClass:!operations!private! !
!PC1ProductProtector categoriesFor: #decipherMethod:!operations!private! !
!PC1ProductProtector categoriesFor: #decryptClasses:!operations!public! !
!PC1ProductProtector categoriesFor: #encryptClasses:!operations!public! !
!PC1ProductProtector categoriesFor: #hashKeyWith:!helpers!public! !
!PC1ProductProtector categoriesFor: #methodsOf:do:!operations!private! !

