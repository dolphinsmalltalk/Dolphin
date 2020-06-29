"Filed out from Dolphin Smalltalk 7"!

DolphinSureCertificate subclass: #ObjectArtsCertificate
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ObjectArtsCertificate guid: (GUID fromString: '{a543c6d9-2907-46b9-b22e-4c066703c2ee}')!
ObjectArtsCertificate comment: ''!
!ObjectArtsCertificate categoriesForClass!Cryptography-Certificates! !
!ObjectArtsCertificate class methodsFor!

generate
	"Private - Generates an instance of the receiver

	self generate show
"

	| info |
	info := (DolphinSureCertificateInfo serial: 'RE108003' owner: 'Object Arts Ltd' publicKey: self publicKey).
	^(DolphinSureCertificate basicNew)
		publisherCertificate: ObjectArtsRootCertificate new;
		info: info privateKey: ObjectArtsRootCertificate privateKey.
	!

new
	"Answers an instance of the receiver. 

	The byte array should be regenerated using the following expression if the data content of an instance changes:
	self generate binaryStoreBytes.

	Show the exsiting certificate:
	self new show.
	DolphinSureCertificateStore myCertificates addCertificate: self new.
"

	^Object 
		fromBinaryStoreBytes: #[33 83 84 66 32 51 32 6 4 22 0 68 111 108 112 104 105 110 83 117 114 101 67 101 114 116 105 102 105 99 97 116 101 114 0 0 0 204 0 0 0 33 83 84 66 32 51 32 6 6 26 0 68 111 108 112 104 105 110 83 117 114 101 67 101 114 116 105 102 105 99 97 116 101 73 110 102 111 82 0 0 0 8 0 0 0 82 69 49 48 56 48 48 51 82 0 0 0 15 0 0 0 79 98 106 101 99 116 32 65 114 116 115 32 76 116 100 82 0 0 0 0 0 0 0 6 1 4 0 68 97 116 101 113 43 1 0 0 0 0 0 130 0 0 0 96 0 0 0 194 198 186 38 2 246 29 161 133 146 190 194 191 75 81 196 208 66 109 156 133 94 234 249 104 184 7 126 214 141 94 178 172 231 11 65 67 9 146 131 144 23 135 176 38 228 169 95 140 79 88 167 59 154 52 76 93 191 243 93 240 20 67 134 165 189 253 195 247 177 187 53 138 106 180 158 120 232 242 204 63 13 120 139 60 13 5 22 9 130 51 166 101 180 227 10 82 0 0 0 22 0 0 0 68 111 108 112 104 105 110 83 117 114 101 67 101 114 116 105 102 105 99 97 116 101 82 0 0 0 105 0 0 0 91 68 83 65 32 100 105 103 105 116 97 108 32 115 105 103 110 97 116 117 114 101 32 53 65 69 70 69 54 70 68 67 55 55 50 67 48 69 65 65 57 70 70 69 49 70 68 56 55 65 66 67 53 54 67 56 52 53 67 65 56 51 50 32 56 55 69 69 67 69 68 54 54 51 52 66 53 67 52 69 48 49 54 48 48 66 68 65 67 53 50 57 65 67 67 69 50 54 69 66 51 70 65 52 93 0 0 0 0]!

publicKey
	"Private - Answer the Object Arts public key

	self new publicKey"

	^66039458397669803647992801463125010145276767112844584879143373549225036982587359720251339756294058302428366980445354710008957200698967543782167927164237991614924004432935103089474244058711692162907336641464545316822523525497276098!

validYears
	"Private - Answer the number of years that certificates of this class should be valid
	for by default. Nil indicates valid indefinitely."

	^nil! !
!ObjectArtsCertificate class categoriesFor: #generate!instance creation!private! !
!ObjectArtsCertificate class categoriesFor: #new!instance creation!public! !
!ObjectArtsCertificate class categoriesFor: #publicKey!constants!private! !
!ObjectArtsCertificate class categoriesFor: #validYears!constants!private! !

