"Filed out from Dolphin Smalltalk 7"!

Object subclass: #DolphinSureTrustedData
	instanceVariableNames: 'data description signature publisherCertificate'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DolphinSureTrustedData guid: (GUID fromString: '{6ba876e9-8f00-4f03-bed6-f2f6af4edbf1}')!
DolphinSureTrustedData comment: 'A DolphinSureTrustedData object represents data that has been encrypted with a particular publisher''s certificate.  The intent is that the data can be guaranteed as originating from a particular publisher (identified by the encapsulated certificate) and that it can also be trusted not to have been modified since it was published.  It is not used as a means of transmitting "secret" data (since anyone can directly see it) but as a means of transmitting signed data.

In order to create a piece of signed/trusted data it is necessary to have a DolphinSureCertificate and a matching private key.  These can be obtained by applying to a DolphinSure certificate authority such as Object Arts Ltd (http://www.object-arts.com/DolphinSure). The raw data is signed by first hasing with the SecurehashAlgorithm and then encrypting the result using the DigitalSignatureAlgorithm and the private key of the publisher''s certificate. The point is that, the key can be easily verified to match the hash of the data and it is therefore very difficult to forge another message that pertains to be from the same source.

Example:

"Create the trusted data"
trusted := DolphinSureTrustedData data: ''This message cannot be tampered with'' asByteArray
	description: ''A test''
	publisherCertificate: myCertificate 
	privateKey: myCertificate class privateKey.

"Display the publisher''s certificate and decode the original data."
trusted publisherCertificate show.

"Is the data valid"
trusted isValid.

"Verify that it is acceptable to access this data"
trusted trustedData asString. "Display it"

"Try modifying the data"
trusted data at: 1 put: 99.
trusted trustedData asString. "Display it"

Instance Variables:
	data			<ByteArray> containing the encoded data bytes.
	description			<readableString> descripting the signed data
	signature			<integer> an encoded version of a hash of the data.
	publisherCertificate		<DolphinSureCertificate> identifying the message publisher.

'!
!DolphinSureTrustedData categoriesForClass!Cryptography-Support! !
!DolphinSureTrustedData methodsFor!

data
	"Answers the decoded information for the receiver without verifying that it is correct."

	^data!

data: aByteArray description: aString privateKey: privateKey
	"Set the encoded data held by the receiver to aByteArray and sign it
	using the private key."

	| fullPrivateKey |
	data := aByteArray.
	description := aString.
	fullPrivateKey := self class keyGroup copyWith: privateKey.
	signature := self class signatureAlgorithm sign: self dataToSign privateKey: fullPrivateKey.
	 !

data: aByteArray description: aString signature: signatureString
	"Set the encoded data held by the receiver to aByteArray with aStignatureString"

	data := aByteArray.
	description := aString.
	signature := signatureString.
	 !

dataToSign
	"Private - Answers a ByteArray of the data that should be signed. This is the raw data with 
	the bytes of the publisher's public key appended. By doing this we find that we
	don't need to validate the publisher's certificate each time we validate the receiver.
	This saves valuable time when validating the receiver's data"

	^data , self description asByteArray, (self publisherPublicKey shallowCopy becomeA: ByteArray)
!

description
	"Answers the description of the receiver"

	^description!

isValid
	"Answer true if the data can be considered to be valid. The decoded hash value
	must match the hash of the decoded data."

	| fullPublicKey |
	fullPublicKey := self class keyGroup copyWith: self publisherCertificate publicKey.
	^self class signatureAlgorithm verify: self signature isSignatureOf: self dataToSign publicKey:  fullPublicKey.



!

publisher
	"Answers the information for the publisher of the receiver"

	^self publisherCertificate info
	 !

publisherCertificate
	"Answers the certificate for the publisher of the receiver"

	^publisherCertificate ifNil: [ObjectArtsRootCertificate new]!

publisherCertificate: certificate
	"Private - Initialize the receiver with the given certificate"

	publisherCertificate := (certificate publicKey=ObjectArtsRootCertificate publicKey) 	ifFalse: [certificate].
	 !

publisherPublicKey
	"Private - Answer the publisher's public key"

	^self publisherCertificate publicKey!

signature
	"Answers the signature of the receiver"

	^signature
	 !

trustedData
	"Answer the signed data containing the receiver's contents after verifying the users trust in it"

	| validData |
	validData := self validData.
	(self publisherCertificate confirmTrustFor: self description) ifFalse: [ 
		NotTrustedError signal: self description].
	^validData
!

validData
	"Checks the receiver's data to see if it is valid. Signals a TrustedDataError if it
	has been tampered with. Otherwise answers the valid data"

	self isValid ifFalse: [ 
		TrustedDataError signal ].
	^self data
!

validDataPublishedBy: aPublisherCertificate
	"Checks the receiver's data to see if it is valid and published by aPublisherCertificate.
	Signals a TrustedDataError if it has been tampered with or is published by someone else. 
	Otherwise answers the valid data"

	self publisherCertificate = aPublisherCertificate ifFalse: [TrustedDataError signal].
	^self validData! !
!DolphinSureTrustedData categoriesFor: #data!accessing!public! !
!DolphinSureTrustedData categoriesFor: #data:description:privateKey:!accessing!public! !
!DolphinSureTrustedData categoriesFor: #data:description:signature:!accessing!public! !
!DolphinSureTrustedData categoriesFor: #dataToSign!accessing!private! !
!DolphinSureTrustedData categoriesFor: #description!accessing!public! !
!DolphinSureTrustedData categoriesFor: #isValid!public!testing! !
!DolphinSureTrustedData categoriesFor: #publisher!accessing!public! !
!DolphinSureTrustedData categoriesFor: #publisherCertificate!accessing!public! !
!DolphinSureTrustedData categoriesFor: #publisherCertificate:!initializing!private! !
!DolphinSureTrustedData categoriesFor: #publisherPublicKey!accessing!private! !
!DolphinSureTrustedData categoriesFor: #signature!accessing!public! !
!DolphinSureTrustedData categoriesFor: #trustedData!accessing!public! !
!DolphinSureTrustedData categoriesFor: #validData!accessing!public! !
!DolphinSureTrustedData categoriesFor: #validDataPublishedBy:!accessing!public! !

!DolphinSureTrustedData class methodsFor!

binaryReadFrom: aStream context: anObject 
	"Answers an object read from its binary STB representation on aStream. Because STB is
	inherently an insecure format (loading objects can cause arbitrary code to be run) we must
	use a special STBInFiler (an STBValidatingInFiler) that will only load a restricted set of
	classes that we know to be passive."

	| inFiler validClasses |
	validClasses := (Set new)
				add: #String;
				add: #ByteArray;
				addAll: self secureCertificateClassNames;
				add: self name;
				yourself.
	inFiler := (STBValidatingInFiler on: aStream)
				context: anObject;
				validationBlock: [:className | validClasses identityIncludes: className];
				yourself.
	^inFiler next!

data: aByteArray description: aString publisherCertificate: certificate privateKey: privateKey
	"Answer an instance of the receiver using the supplied publisher certificate and aByteArray of data
	signed using the supplied private key"

	^(self publisherCertificate: certificate) data: aByteArray description: aString privateKey: privateKey.!

data: aByteArray description: aString publisherCertificate: certificate signature: signatureString
	"Answer an instance of the receiver using the supplied publisher certificate and aByteArray of data
	with the supplied signatureString"

	^(self publisherCertificate: certificate) data: aByteArray description: aString signature: signatureString!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

keyGroup
	"Private - Answers the key group for all instances of the receiver. This is a partial key that can be combined with
	the public and private keys to form the full public and private keys. Using a common group such as this
	is allowed by the signing algorithm (usually DSA) and allows us to keep the distributed key sizes to
	a minimum.

	DigitalSignatureAlgorithm generateKeyGroup
"

	^#(1344959975021183998377461493829832346019290168821432994436741829364145974031337288122071999657253530933444584731247323302556985479556803586272620768100670816117923392630651028718714009063424604679646654789674271745108534683106059919 971209540074985050927241296900002108416639808401 1098037283183512488972671849889263265422442210162981688540072139599588773753639989826335346459418748852820516839755754786131722650564117163355594795493726077066289894371168531949981064463448675126577336382530407601403886127111817040)!

parseByteArrayChunk: aString 
	"Private - Parse the literal byte array in the <readableString> argument. We must not use
	the Compiler, as the data is untrusted."

	| text bytes |
	bytes := ReadWriteStream on: ByteArray new.
	text := aString readStream.
	text skipWhile: [:each | each isDigit not].
	
	[text skipSeparators.
	text atEnd or: [text peekFor: $]]] 
			whileFalse: [bytes nextPut: (Integer readFrom: text)].
	^bytes
		reset;
		yourself!

publisherCertificate: certificate
	"Answer an instance of the receiver using the supplied publisher certificate"

	^super new publisherCertificate: certificate!

secure
	"Answer a chunk reader to read a trusted chunk."

	| chunks |
	chunks := OrderedCollection new.
	^ChunkReader do: [:chunk | chunks addLast: chunk]
		atEnd: 
			[| data certificate bytes |
			bytes := self parseByteArrayChunk: (chunks at: 3).
			certificate := self binaryReadFrom: bytes context: nil.
			data := self 
						data: (chunks at: 4)
						description: (chunks at: 1)
						publisherCertificate: certificate
						signature: (chunks at: 2).
			(ChunkSourceFiler on: data trustedData readStream) fileIn]!

secureCertificateClassNames
	"These are the names of the certificate classes that can be loaded from a secure chunk."

	^#(#DolphinSureCertificate #DolphinSurePersonalCertificate)!

signatureAlgorithm
	"Private - Answer the signature algorithm of the receiver"

	^DigitalSignatureAlgorithm! !
!DolphinSureTrustedData class categoriesFor: #binaryReadFrom:context:!binary filing!public! !
!DolphinSureTrustedData class categoriesFor: #data:description:publisherCertificate:privateKey:!instance creation!public! !
!DolphinSureTrustedData class categoriesFor: #data:description:publisherCertificate:signature:!instance creation!public! !
!DolphinSureTrustedData class categoriesFor: #icon!constants!development!public! !
!DolphinSureTrustedData class categoriesFor: #keyGroup!accessing!private! !
!DolphinSureTrustedData class categoriesFor: #parseByteArrayChunk:!helpers!private!source filing! !
!DolphinSureTrustedData class categoriesFor: #publisherCertificate:!instance creation!public! !
!DolphinSureTrustedData class categoriesFor: #secure!public!source filing! !
!DolphinSureTrustedData class categoriesFor: #secureCertificateClassNames!constants!public! !
!DolphinSureTrustedData class categoriesFor: #signatureAlgorithm!accessing!private! !

