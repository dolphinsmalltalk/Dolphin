"Filed out from Dolphin Smalltalk 7"!

Security.DolphinSureCertificate subclass: #'Security.NotSignedCertificate'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Security.NotSignedCertificate guid: (Core.GUID fromString: '{1284a49f-307e-4ea7-a404-ea7e7a56cbfe}')!
Security.NotSignedCertificate comment: 'A NotSignedCertificate is used to indicate when a piece of data has not been digitally signed using DolphinSure.  Typically it is used by BinaryPackage>>loadUsing: when a binary class file is being loaded and it is discovered that the class data has not been signed. 

Although it may seem strange to have a certificate for this purpose, it does allow the user to elect to install the NotSignedCertificate in his or her temporary trust store.  By doing so, a user can avoid repeated warnings about loading unsigned classes for the duration of the current Dolphin session. The temporary trust store is cleared out whenever an image is started so unsigned classes cannot be trusted indefinitely.

NotSignedCertificate new confirmTrustFor: ''Unsigned data'''!
!Security.NotSignedCertificate categoriesForClass!Cryptography-Certificates! !
!Security.NotSignedCertificate methodsFor!

backgroundImageFile
	"Private - Answers the resource name of the background image file
	for the receiver"

	^'Resources/DolphinSureNotSignedCert.jpg'
!

canBePermanentlyTrusted
	"Answer true if the receiver can be added to the permanent trust store.
	It is obviously not safe to always trust unsigned content."

	^false!

imageAttributes
	"Private - Answers an OrderedCollection detailing the attributes that should
	appear on a image displaying the certificate details"

	^##(OrderedCollection new
		add: '' -> #gap;
		add: 'IMPORTANT:' -> #purpose;
		yourself)!

purpose
	"Answers the purpose of this certificate"

	^'The content you are about to load has not been digitally signed. 

It is therefore not possible to guarantee the identity of the publisher or ensure that the content has not been modified since it was originally published. 

You must decide if you are willing to accept this content as safe.'! !
!Security.NotSignedCertificate categoriesFor: #backgroundImageFile!constants!private! !
!Security.NotSignedCertificate categoriesFor: #canBePermanentlyTrusted!public!testing!trust! !
!Security.NotSignedCertificate categoriesFor: #imageAttributes!accessing!private! !
!Security.NotSignedCertificate categoriesFor: #purpose!accessing!public! !

!Security.NotSignedCertificate class methodsFor!

new
	"Answers an instance of the receiver. The byte array should be regenerated using the following
	expression if the data content of an instance changes:

		self generate binaryStoreBytes.

		self new show.
	"

	^Object 
		fromBinaryStoreBytes: #[33 83 84 66 32 51 32 6 4 20 0 78 111 116 83 105 103 110 101 100 67 101 114 116 105 102 105 99 97 116 101 114 0 0 0 201 0 0 0 33 83 84 66 32 51 32 6 6 26 0 68 111 108 112 104 105 110 83 117 114 101 67 101 114 116 105 102 105 99 97 116 101 73 110 102 111 82 0 0 0 20 0 0 0 78 111 116 83 105 103 110 101 100 67 101 114 116 105 102 105 99 97 116 101 82 0 0 0 0 0 0 0 192 1 0 0 6 1 4 0 68 97 116 101 97 46 1 0 0 0 0 0 130 0 0 0 100 0 0 0 8 219 150 216 90 113 81 215 68 14 17 21 135 231 2 178 111 238 239 30 199 88 92 179 189 9 16 162 60 243 121 252 122 152 133 113 28 33 145 205 222 103 117 189 24 239 32 245 69 121 0 91 196 27 120 23 128 154 115 129 62 122 219 165 228 79 63 219 36 63 133 5 131 27 30 17 255 236 32 65 20 6 206 231 63 49 58 99 5 227 64 68 206 22 113 185 0 0 0 0 82 0 0 0 20 0 0 0 78 111 116 83 105 103 110 101 100 67 101 114 116 105 102 105 99 97 116 101 82 0 0 0 105 0 0 0 91 68 83 65 32 100 105 103 105 116 97 108 32 115 105 103 110 97 116 117 114 101 32 52 54 67 70 67 65 68 52 68 53 53 66 66 68 50 53 57 53 50 53 55 49 70 48 51 55 53 65 50 55 70 51 68 68 52 53 68 56 69 54 32 53 54 70 48 57 54 68 53 50 50 70 50 56 48 50 52 66 56 50 69 68 70 51 54 65 52 53 53 65 68 69 69 57 49 56 53 66 50 67 51 93 0 0 0 0]!

publicKey
	"Private - Answer the NotSignedCertificate public key"

	^1124615931727258249974878279119386805335984434495768699950180425504229791113404642158796224686992028830604366070075512630691030230992145898708293454093495833859797530900650433759655495629145854226934202801436679404370370812200803080
!

validYears
	"Private - Answer the number of years that certificates of this class should be valid
	for by default. Nil indicates valid indefinitely."

	^1! !
!Security.NotSignedCertificate class categoriesFor: #new!instance creation!public! !
!Security.NotSignedCertificate class categoriesFor: #publicKey!constants!private! !
!Security.NotSignedCertificate class categoriesFor: #validYears!constants!private! !

