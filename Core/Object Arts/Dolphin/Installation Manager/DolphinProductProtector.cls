"Filed out from Dolphin Smalltalk X6.1"!

PC1ProductProtector subclass: #DolphinProductProtector
	instanceVariableNames: 'base64codec cipher cipher2'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinProductProtector guid: (GUID fromString: '{7D5F8744-7D21-4D06-838C-3E9F18F43AE4}')!
DolphinProductProtector comment: 'Differs from superclass by emitting methods in sorted order and using a single encryption cipher, rather than one per method.'!
!DolphinProductProtector categoriesForClass!Unclassified! !
!DolphinProductProtector methodsFor!

cipher
	^cipher!

cipherMethod: aCompiledMethod 
	"Private - Encrypts/Decrypts aCompiledMethod using our key."

	"Implementation note: we replace the bytecode array with an encrypted version.  Oddly
	this is not affected by the image stripper merging duplicate bytecodes  since if the result
	happens to be the same as the bytecode of any other method (encrypted or not, with
	the same or different key) the decryption process will naturally un-merge the duplication"

	| bytes source encryptedBytes encryptedSource decryptedBytes decryptedSource byteStream method |
	bytes := aCompiledMethod byteCodes.
	source := aCompiledMethod getSource.
	encryptedBytes := cipher cipherBytes: bytes.
	encryptedSource := String writeStream.
	base64codec encodeFrom: (cipher cipherBytes: source asByteArray) readStream onto: encryptedSource.
	encryptedSource := encryptedSource contents.
	aCompiledMethod
		setByteCodes: encryptedBytes;
		storeSourceString: encryptedSource.
	"method := Object fromBinaryStoreBytes: aCompiledMethod binaryStoreBytes.
	methods add: method.
	method
		setByteCodes: encryptedBytes;
		storeSourceString: encryptedSource."
	method := aCompiledMethod.
	decryptedBytes := cipher2 cipherBytes: method byteCodes.
	byteStream := ByteArray writeStream.
	base64codec decodeFrom: method getSource readStream onto: byteStream.
	decryptedSource := (cipher2 cipherBytes: byteStream contents) asString.
	self assert: [decryptedBytes = bytes].
	self assert: [decryptedSource = source]!

decipherMethod: aCompiledMethod 
	"Private - Decrypts aCompiledMethod using our key."

	| encryptedBytecodes encryptedSource decryptedBytecodes decryptedSource encryptedSourceBytes |
	encryptedBytecodes := aCompiledMethod byteCodes.
	encryptedSource := aCompiledMethod getSource.
	decryptedBytecodes := cipher cipherBytes: encryptedBytecodes.
	encryptedSourceBytes := ByteArray writeStream.
	base64codec decodeFrom: encryptedSource readStream onto: encryptedSourceBytes.
	decryptedSource := (cipher cipherBytes: encryptedSourceBytes contents) asString.
	aCompiledMethod
		byteCodes: decryptedBytecodes;
		storeSourceString: decryptedSource!

key: aKeyObject 
	super key: aKeyObject.
	base64codec := Base64Codec new.
	cipher := (PC1Cipher withKeyInteger: aKeyObject)
				advance: self class identityHash % 255 + 200;
				yourself.
	cipher2 := cipher copy
	"methods := IdentitySet new."!

methodsOf: aClass do: aBlockClosure 
	(aClass methodDictionary asSortedCollection: [:a :b | (a selector trueCompare: b selector) <= 0]) 
		do: [:each | each whileMutableDo: [aBlockClosure value: each]]! !
!DolphinProductProtector categoriesFor: #cipher!accessing!private! !
!DolphinProductProtector categoriesFor: #cipherMethod:!operations!private! !
!DolphinProductProtector categoriesFor: #decipherMethod:!operations!private! !
!DolphinProductProtector categoriesFor: #key:!initializing!private! !
!DolphinProductProtector categoriesFor: #methodsOf:do:!operations!private! !

