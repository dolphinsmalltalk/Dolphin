"Filed out from Dolphin Smalltalk 7"!

DolphinSureCertificationAuthorityCertificate subclass: #ObjectArtsRootCertificate
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ObjectArtsRootCertificate guid: (GUID fromString: '{01ab17af-ef96-4982-a998-0d75dc9c4159}')!
ObjectArtsRootCertificate comment: 'The ObjectArtsCertificate class is used to represent the root DolphinSure certifying authority certificate for Object Arts Ltd. The actual encoded certificate data is held in the #new class method.  We specially include this class here to act as the root of the DolphinSureTrustedData trust hierarchy.

If you wish to display the Object Arts root certificate, you can evaluate:

ObjectArtsRootCertificate new show.'!
!ObjectArtsRootCertificate categoriesForClass!Cryptography-Certificates! !
!ObjectArtsRootCertificate methodsFor!

publicKey
	"Answer the public key of the receiver"

	^self class publicKey!

publisherPublicKey
	"Private - Answer the publisher's public key"

	^self publicKey! !
!ObjectArtsRootCertificate categoriesFor: #publicKey!accessing!public! !
!ObjectArtsRootCertificate categoriesFor: #publisherPublicKey!accessing!private! !

!ObjectArtsRootCertificate class methodsFor!

generate
	"Private - Generates an instance of the receiver
	
	self generate
	"

	| oaCert info |
	info := (DolphinSureCertificateInfo serial: 'OA1100' owner: 'Object Arts Ltd' publicKey: self publicKey).
	^(oaCert := self basicNew)
		publisherCertificate: oaCert;
		info: info privateKey: self privateKey.
	!

new
	"Answers an instance of the receiver. The byte array should be regenerated using the following
	expression if the data content of an instance changes:

		self generate binaryStoreBytes.

		self new show
	"

	^Object 
		fromBinaryStoreBytes: #[33 83 84 66 32 51 32 6 4 25 0 79 98 106 101 99 116 65 114 116 115 82 111 111 116 67 101 114 116 105 102 105 99 97 116 101 114 0 0 0 202 0 0 0 33 83 84 66 32 51 32 6 6 26 0 68 111 108 112 104 105 110 83 117 114 101 67 101 114 116 105 102 105 99 97 116 101 73 110 102 111 82 0 0 0 6 0 0 0 79 65 49 49 48 48 82 0 0 0 15 0 0 0 79 98 106 101 99 116 32 65 114 116 115 32 76 116 100 82 0 0 0 0 0 0 0 6 1 4 0 68 97 116 101 77 43 1 0 0 0 0 0 130 0 0 0 96 0 0 0 70 198 227 9 112 85 145 79 9 232 238 69 191 77 81 133 116 19 125 176 125 233 53 42 7 15 22 49 149 3 153 153 39 42 163 7 95 171 99 207 20 197 204 102 189 37 149 174 205 231 99 148 6 233 87 201 50 222 109 168 20 215 205 224 6 180 168 214 180 202 232 211 164 189 215 90 230 164 90 23 19 211 173 50 97 82 222 255 135 173 214 125 28 111 255 61 82 0 0 0 25 0 0 0 79 98 106 101 99 116 65 114 116 115 82 111 111 116 67 101 114 116 105 102 105 99 97 116 101 82 0 0 0 105 0 0 0 91 68 83 65 32 100 105 103 105 116 97 108 32 115 105 103 110 97 116 117 114 101 32 50 48 56 68 51 51 69 53 54 52 68 70 67 49 48 65 55 48 55 56 70 66 66 57 69 67 67 67 70 70 66 48 67 69 53 70 66 69 55 70 32 52 66 57 70 66 52 65 65 70 55 68 56 48 54 56 66 48 55 50 48 51 70 66 51 52 67 56 52 68 51 54 48 69 67 52 50 65 68 55 48 93 0 0 0 0]!

publicKey
	"Private - Answer the Object Arts public key"

	^375987067871066086189319489826807907991037401565270554933403098864237018461081502899061579655189075262166164962154491091294320985229981725506100991338395436830936709590340228966393702463042094571064096039561910657624822723679340102!

validYears
	"Private - Answer the number of years that certificates of this class should be valid
	for by default. Nil indicates valid indefinitely."

	^nil! !
!ObjectArtsRootCertificate class categoriesFor: #generate!instance creation!private! !
!ObjectArtsRootCertificate class categoriesFor: #new!instance creation!public! !
!ObjectArtsRootCertificate class categoriesFor: #publicKey!constants!public! !
!ObjectArtsRootCertificate class categoriesFor: #validYears!constants!private! !

