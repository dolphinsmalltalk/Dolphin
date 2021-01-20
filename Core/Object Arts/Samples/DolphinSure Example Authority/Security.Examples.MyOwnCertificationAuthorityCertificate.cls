"Filed out from Dolphin Smalltalk 7"!

DolphinSureCertificationAuthorityCertificate subclass: #MyOwnCertificationAuthorityCertificate
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MyOwnCertificationAuthorityCertificate guid: (GUID fromString: '{3a6b1632-077d-49f5-81be-ed0688e9c2b0}')!
MyOwnCertificationAuthorityCertificate comment: ''!
!MyOwnCertificationAuthorityCertificate categoriesForClass!Cryptography-Certificates! !
!MyOwnCertificationAuthorityCertificate methodsFor!

publicKey
	"Answer the public key of the receiver"

	^self class publicKey!

publisherPublicKey
	"Private - Answer the publisher's public key"

	^self publicKey! !
!MyOwnCertificationAuthorityCertificate categoriesFor: #publicKey!accessing!public! !
!MyOwnCertificationAuthorityCertificate categoriesFor: #publisherPublicKey!accessing!private! !

!MyOwnCertificationAuthorityCertificate class methodsFor!

generate
	"Private - Generates an instance of the receiver
	
	self generate
	"

	| oaCert info |
	info := (DolphinSureCertificateInfo serial: 'MY100001' owner: 'My Own Company Inc.' publicKey: self publicKey).
	^(oaCert := self basicNew)
		publisherCertificate: oaCert;
		info: info privateKey: self privateKey.
	!

new
	"Answers an instance of the receiver. 

	Show an instance of the receiver using:
		self new show.

	The instance is regenerated from a binary store string. If the data content of the certificate changes then the binary store
	array contained in this method should be recreated (and pasted below) by displaying the following:

		self generate binaryStoreBytes.
	"

	^Object 
		fromBinaryStoreBytes: #[33 83 84 66 32 51 32 6 4 38 0 77 121 79 119 110 67 101 114 116 105 102 105 99 97 116 105 111 110 65 117 116 104 111 114 105 116 121 67 101 114 116 105 102 105 99 97 116 101 114 0 0 0 212 0 0 0 33 83 84 66 32 51 32 6 6 26 0 68 111 108 112 104 105 110 83 117 114 101 67 101 114 116 105 102 105 99 97 116 101 73 110 102 111 82 0 0 0 8 0 0 0 77 89 49 48 48 48 48 49 82 0 0 0 19 0 0 0 77 121 32 79 119 110 32 67 111 109 112 97 110 121 32 73 110 99 46 82 0 0 0 0 0 0 0 6 1 4 0 68 97 116 101 87 46 1 0 0 0 0 0 130 0 0 0 100 0 0 0 57 120 179 107 23 79 103 48 31 76 201 62 64 174 221 44 197 95 55 148 34 88 138 11 61 155 119 116 177 38 52 116 165 197 190 216 12 225 55 92 55 203 141 206 190 88 122 250 78 77 113 204 156 177 3 79 105 156 51 89 197 82 117 43 175 192 93 172 236 18 81 141 54 165 181 247 31 123 59 200 28 234 198 146 185 5 160 159 153 154 5 30 57 191 34 155 0 0 0 0 82 0 0 0 38 0 0 0 77 121 79 119 110 67 101 114 116 105 102 105 99 97 116 105 111 110 65 117 116 104 111 114 105 116 121 67 101 114 116 105 102 105 99 97 116 101 82 0 0 0 105 0 0 0 91 68 83 65 32 100 105 103 105 116 97 108 32 115 105 103 110 97 116 117 114 101 32 55 66 68 66 53 67 56 69 66 51 66 48 56 57 53 49 55 67 53 54 68 66 53 67 55 69 66 57 53 48 50 55 54 54 51 55 69 66 65 50 32 52 50 54 65 48 70 54 53 48 54 67 57 69 50 48 51 55 56 68 48 51 50 54 67 65 50 68 55 57 50 48 51 57 53 48 68 50 70 54 57 93 160 1 0 0]!

privateKey
	"Private - Answer the My Certification Authority private key. 
	Obviously this should not be revealed to anyone

	Generate a private/public key pair by displaying the following:
		DigitalSignatureAlgorithm generateKeySetForGroup: self keyGroup

	Paste the first number (the private key) below and the second number (the public key) in
	the #publicKey method.
"

	^313527987137277943694956748927222488711739877201!

publicKey
	"Private - Answer the public key for My Certification Authority"

	^940824328533295492391444169970119827836398587147571753713179774395123442265152547402571195110092581180143173539219431883096110317709222457924802123895560948635836999737949981261830467788409999248537922147589867328417237650998786105!

validYears
	"Private - Answer the number of years that certificates of this class should be valid
	for by default. Nil indicates valid indefinitely."

	^nil! !
!MyOwnCertificationAuthorityCertificate class categoriesFor: #generate!instance creation!private! !
!MyOwnCertificationAuthorityCertificate class categoriesFor: #new!instance creation!public! !
!MyOwnCertificationAuthorityCertificate class categoriesFor: #privateKey!constants!private! !
!MyOwnCertificationAuthorityCertificate class categoriesFor: #publicKey!constants!public! !
!MyOwnCertificationAuthorityCertificate class categoriesFor: #validYears!constants!private! !

