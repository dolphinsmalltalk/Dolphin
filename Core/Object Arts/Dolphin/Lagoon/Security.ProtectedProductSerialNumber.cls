"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Security.ProtectedProductSerialNumber'
	instanceVariableNames: 'value stringValue'
	classVariableNames: 'FixedLicenceMask'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Security.ProtectedProductSerialNumber guid: (Core.GUID fromString: '{1e38759a-1c4b-4b07-bfa7-2b47b361a5d1}')!
Security.ProtectedProductSerialNumber isNonInstantiable: true!
Security.ProtectedProductSerialNumber comment: 'This class acts as an abstract superclass for serial numbers of protected products. A protected product can be encrypted using the #decodingKey of a serial number. The encryption process garbles the bytecodes of the product''s compiled methods so the application will not run successfully until it is decrypted by the same #decodingKey.

Concrete subclasses should be created either for each product created or, more likely, for each publishing author. These subclasses must override the following methods (all on the class side) as described in the method comments:

	#instanceDecodingKey
	#lockedMethodDecodingKey
	#lockedMethodDecodingKeyHash

Assuming you have created a concrete subclass called MyCompanySerialNumber, you can issue serial numbers for your products by using:

	sn := MyCompanySerialNumber new.
	sn displayString "Hand this out to a user"
	sn productId "This is the internal unique number identifying the product purchase"

If you find that a serial number has been illegally distributed to others you can find the origin (i.e. who it was originally sold to) by:

	sn2 := MyCompanySerialNumber fromString: ''1CU5C-JGI7N-YL2YI-WATKAL''.
	sn2 isValid. "True if the serial number string is valid"
	sn2 productId. "Identifies the original owner"

For a simple example see the ''Protected Scribble'' sample package (under Samples/Lagoon/Product Protection/).

It is possible to override more of the class-side methods in the ''constants'' category in order to use different encryption of both the serial number itself, and of the ''garbled'' methods.  The ''Protected Notepad'' sample application showns one example of this.'!
!Security.ProtectedProductSerialNumber categoriesForClass!Cryptography-Support! !
!Security.ProtectedProductSerialNumber methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: self stringValue!

expiry
	"Answer the expiry of the receiver in months (from 1st Oct 2000)."

	^self split at: 3!

flags
	"Answer the flags for the receiver (a byte value)."

	^self split at: 2!

isFixedLicence
	"Answer true if the receiver is for a fixed machine."

	^self flags allMask: FixedLicenceMask!

isFloatingLicence
	"Answer true if the receiver is for floating between machines."

	^self isFixedLicence not!

isTrial
	"Answer true if the receiver is for a trial."

	^self isValid and: [self expiry ~= 0]!

isValid
	"Answer true if the receiver appears to be valid. We do this by comparing the SHA hash of the decodingKey
	with the value that we expect.
	NB: this does NOT make use of the #expiry or other flags.  It only checks the validity of the supplied key."

	^self value notNil and: [self lockedMethodDecodingKeyHash = self class lockedMethodDecodingKeyHash]!

lockedMethodDecodingKey
	"Answer the puported key that will be used (if it satisfied the validity check) for decoding
	the locked methods in a deployed application."

	^self split at: 4!

lockedMethodDecodingKeyHash
	"Answer the SHA1 hash of the puported method decoding key of the receiver."

	^[SecureHashAlgorithm new hashInteger: self lockedMethodDecodingKey] on: Error
		do: [:err | ^nil]!

printOn: aStream 
	"Append a textual representation of the receiver to the <puttableStream> argument
	as a developer might want to see it."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: self displayString;
		nextPut: $)!

productId
	"Answer the product id of the receiver (this is a rather poorly named method;
	a better name might be #purchaseId since it identifies a particular purchase
	(and hence the buyer)."

	^self split at: 1!

split
	"Private - Answer an Array representing a decoding of the receiver's elements
	1 Product id # <32-bit integer>
	2 Flags <byte>
	3 Expiry months <byte>
	4 Locked method decodingKey (LargeInteger of indeterminate size)"

	| number split |
	number := self value.
	split := Array new: 4.

	"product id"
	split at: 1 put: number & 16rFFFFFFFF.
	number := number >> 32.

	"flags"
	split at: 2 put: number & 16rFF.
	number := number >> 8.

	"expiry"
	split at: 3 put: number & 16rFF.
	number := number >> 8.

	"and whatever's left over is the unlock key"
	split at: 4 put: number.
	^split!

stringValue
	"Private - Answer the encoded serial number value as a human-readable String."

	"lazily create encrypted string"

	stringValue isNil 
		ifTrue: 
			[| coder |
			coder := self class instanceEncoder.
			stringValue := coder encryptToString: self value].
	^stringValue!

stringValue: aString 
	"Private - Set the encoded serial number value to the given human-readable string."

	| coder |
	coder := self class instanceDecoder.
	[self value: (coder decryptFromString: aString)] on: Error do: [:err | self value: nil].
	stringValue := aString!

value
	"Private - Answer the unencoded serial number value"

	^value!

value: anInteger 
	"Private - Set the unencoded serial number value"

	value := anInteger.
	stringValue := nil! !
!Security.ProtectedProductSerialNumber categoriesFor: #displayOn:!displaying!public! !
!Security.ProtectedProductSerialNumber categoriesFor: #expiry!accessing!public! !
!Security.ProtectedProductSerialNumber categoriesFor: #flags!accessing!public! !
!Security.ProtectedProductSerialNumber categoriesFor: #isFixedLicence!public!testing! !
!Security.ProtectedProductSerialNumber categoriesFor: #isFloatingLicence!public!testing! !
!Security.ProtectedProductSerialNumber categoriesFor: #isTrial!public!testing! !
!Security.ProtectedProductSerialNumber categoriesFor: #isValid!public!testing! !
!Security.ProtectedProductSerialNumber categoriesFor: #lockedMethodDecodingKey!accessing!public! !
!Security.ProtectedProductSerialNumber categoriesFor: #lockedMethodDecodingKeyHash!accessing!public! !
!Security.ProtectedProductSerialNumber categoriesFor: #printOn:!printing!public! !
!Security.ProtectedProductSerialNumber categoriesFor: #productId!accessing!public! !
!Security.ProtectedProductSerialNumber categoriesFor: #split!accessing!private! !
!Security.ProtectedProductSerialNumber categoriesFor: #stringValue!accessing!private! !
!Security.ProtectedProductSerialNumber categoriesFor: #stringValue:!accessing!initializing!private! !
!Security.ProtectedProductSerialNumber categoriesFor: #value!accessing!private! !
!Security.ProtectedProductSerialNumber categoriesFor: #value:!accessing!initializing!private! !

!Security.ProtectedProductSerialNumber class methodsFor!

fromString: aString 
	"Answers an instance of the receiver read from aString."

	^(self basicNew)
		stringValue: aString;
		yourself!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	FixedLicenceMask := 16r01!

instanceDecoder
	"Answer a suitably configured <SerialNumberProtector> that an instance can use to
	decrypt itself."

	^self serialNumberProtectorClass withKey: self instanceDecodingKey!

instanceDecodingKey
	"Private - Answer the key for decrypting instances from 'public'encrypted  serial number strings.

	If you are using the default <SerialNumberProtector> (even though it is rather weak,
	as described in the PC1SerialNumberProtector class comment) then a suitable
	key can be generated by evaluating the expression below and returning the resultant
	Integerfrom the method overridden in the subclass.   However note that keys
	created in this way do not have much strength.  If you have access to a better
	key generator then use it.

		LargeInteger fromBytes: (PC1Cipher withStrength: 56) key.
	"

	^self subclassResponsibility!

instanceEncoder
	"Answer a suitably configured <SerialNumberProtector> that an instance can use to
	encrypt itself."

	^self serialNumberProtectorClass withKey: self instanceEncodingKey!

instanceEncodingKey
	"Private - Answer the key for encrypting instances before converting them into
	'public' serial number strings.

	The default implementation is to answer the #instanceDecodingKey which is
	reasonably if the encryption used for this purpose is symmetric (as it is by
	default).  Subclasses may want to use asymmetric encryption, however,
	in which case it would be necessary to provide an override of this to return
	a suitable private key.

	NB: this method is automatically removed during deployment."

	^self instanceDecodingKey!

isSafeToEncryptWithProductProtection
	"Answer whether it is save to encrypt the receiver's methods as part of the
	the deployment of a Protected Product application."

	^false!

lockClasses: aCollectionOfClasses 
	"Lock the given classes with our #lockedMethodEncodingKey accordiing to the encryption
	policy defined by our #productProtectorClass."

	self newProductProtector lockClasses: aCollectionOfClasses.

	"Forcibly remove any important (for security), but no longer needed, methods"
	self purgeSensitiveMethods!

lockedMethodDecodingKey
	"Private - Answer the key for [un]locking encypted methods in a deployed application.
	This must be unique for each different type of serial number (e.g. for each company).

	If you are using the default PC1 cypher to protect the deployed methods (i.e. your session
	manager's #productProtectorClass answers PC1ProductProtector) then a suitable key can
	be generated by evaluating the expression below and returning the resultant ByteArray from
	the method overridden in the subclass.    However note that keys
	created in this way do not have much strength.  If you have access to a better
	key generator then use it.

		LargeInteger fromBytes: (PC1Cipher withStrength: 56) key.

	NB: this method is automatically removed during deployment."

	^self subclassResponsibility!

lockedMethodDecodingKeyHash
	"Private - Answer the SHA hash of the decoding key, this is not used for cryptographic
	purposes, but in order to allow instances to verify puportedly valid serial numbers
	wihtout actually attempting to unlock the protected classes (which would crash
	Dolphin if it failed, still secure, but not very friendly).

	The value to return in a subclass's implementation of this method can be caclulated
	with an expression like:

			SecureHashAlgorithm new hashInteger: self lockedMethodDecodingKey.

	NB: when the method is exeuted (in a deployed application) the #lockedMethodDecodingKey
	method will no longer be present, which is why you have to return a hard-coded constant.
	"

	^self subclassResponsibility!

lockedMethodEncodingKey
	"Private - Answer the key for locking encypted methods in a deployed application.
	Only exotic implementations of <ProductProtector> are likely to use different keys
	for encoding and decoding, so the default behaviour is to answer the #lockedMethodDecodingKey.

	NB: this method is automatically removed during deployment."

	^self lockedMethodDecodingKey!

new
	"Construct a new serial number for a protected product"

	^self productId: self newProductId!

newProductId
	"Private - Answer a new product id number generated from a GUID"

	^LargeInteger readFrom: (GUID newUnique asString copyFrom: 2 to: 9) readStream radix: 16!

newProductProtector
	^self productProtectorWithKey: self lockedMethodEncodingKey!

productId: id 
	"Construct a serial number for a protected product"

	^self 
		productId: id
		expiry: 0
		flags: 0!

productId: id expiry: expiry flags: flags 
	"Construct a serial number for a protected product with the expiry limit
	set to <Byte> expiry months (from 1st Oct 2000). 
	The unique product id is given by <Integer> id."

	| value |
	self assert: [id between: 0 and: 16rFFFFFFFF].
	self assert: [expiry between: 0 and: 16rFF].
	self assert: [flags between: 0 and: 16rFF].
	value := self lockedMethodDecodingKey.
	value := value << 8.
	value := value | expiry.
	value := value << 8.
	value := value | flags.
	value := value << 32.
	value := value | id.
	^self basicNew value: value!

productProtectorClass
	"Answer the class of <ProductProtectorr> to use for locking/unlocking encrypted classes."

	"by default we use protection based on the fast symmetric PC1 cypher"

	^PC1ProductProtector!

productProtectorWithKey: anIntegerKey 
	"Answer a <ProductProtectorr> which is ready to en/decrypt the classes we wish to protect."

	^self productProtectorClass withKey: anIntegerKey!

purgeSensitiveMethods
	"Forcibly remove any important (for security) methods.
	This is invoked as a protected image is stripped, amd after any methods have been encrypted,
	so it should remove anything that is not needed for encryption but which might reveal how to
	decrypt."

	self withAllSuperclassesDo: 
			[:each | 
			(each class)
				removeSelector: #lockedMethodEncodingKey ifAbsent: [];
				removeSelector: #lockedMethodDecodingKey ifAbsent: [];
				removeSelector: #instanceEncodingKey ifAbsent: []]!

serialNumberProtectorClass
	"Answer the class of <SerialNumberProtector> that will be used for encrypting/decrypting
	the reciever's instances."

	"the default is to use a PC1SerialNumberProtector, even though that is
	relatively weak, please see the class comments on SerialNumberProtector
	and PC1SerialNumberProtector for an overview of the issues involved"

	^PC1SerialNumberProtector!

unlockClasses: aCollectionOfClasses using: aSerialNumber 
	"Unlock the given classes with aSerialNumber accordiing to the encryption
	policy defined by our #productProtectorClass."

	(self productProtectorWithKey: aSerialNumber lockedMethodDecodingKey) 
		unlockClasses: aCollectionOfClasses! !
!Security.ProtectedProductSerialNumber class categoriesFor: #fromString:!instance creation!public! !
!Security.ProtectedProductSerialNumber class categoriesFor: #icon!constants!development!public! !
!Security.ProtectedProductSerialNumber class categoriesFor: #initialize!initializing!private! !
!Security.ProtectedProductSerialNumber class categoriesFor: #instanceDecoder!helpers!public! !
!Security.ProtectedProductSerialNumber class categoriesFor: #instanceDecodingKey!constants!private! !
!Security.ProtectedProductSerialNumber class categoriesFor: #instanceEncoder!helpers!public! !
!Security.ProtectedProductSerialNumber class categoriesFor: #instanceEncodingKey!constants!private! !
!Security.ProtectedProductSerialNumber class categoriesFor: #isSafeToEncryptWithProductProtection!constants!public!testing! !
!Security.ProtectedProductSerialNumber class categoriesFor: #lockClasses:!operations!public! !
!Security.ProtectedProductSerialNumber class categoriesFor: #lockedMethodDecodingKey!constants!private! !
!Security.ProtectedProductSerialNumber class categoriesFor: #lockedMethodDecodingKeyHash!constants!private! !
!Security.ProtectedProductSerialNumber class categoriesFor: #lockedMethodEncodingKey!constants!private! !
!Security.ProtectedProductSerialNumber class categoriesFor: #new!instance creation!public! !
!Security.ProtectedProductSerialNumber class categoriesFor: #newProductId!operations!private! !
!Security.ProtectedProductSerialNumber class categoriesFor: #newProductProtector!helpers!private! !
!Security.ProtectedProductSerialNumber class categoriesFor: #productId:!instance creation!public! !
!Security.ProtectedProductSerialNumber class categoriesFor: #productId:expiry:flags:!instance creation!public! !
!Security.ProtectedProductSerialNumber class categoriesFor: #productProtectorClass!constants!public! !
!Security.ProtectedProductSerialNumber class categoriesFor: #productProtectorWithKey:!helpers!private! !
!Security.ProtectedProductSerialNumber class categoriesFor: #purgeSensitiveMethods!operations!public! !
!Security.ProtectedProductSerialNumber class categoriesFor: #serialNumberProtectorClass!constants!public! !
!Security.ProtectedProductSerialNumber class categoriesFor: #unlockClasses:using:!operations!public! !

