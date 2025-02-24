﻿"Filed out from Dolphin Smalltalk"!

DolphinSureCertificate subclass: #MyOwnCertificate
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MyOwnCertificate guid: (GUID fromString: '{a2592b78-b801-4788-885c-e1c32f062980}')!

MyOwnCertificate comment: ''!

!MyOwnCertificate categoriesForClass!Cryptography-Certificates! !

!MyOwnCertificate methodsFor!

backgroundImageFile
	"Private - Answers the resource name of the background image file
	for the receiver"

	^'Resources/DolphinSurePersonalCert.jpg'
!

imageAttributes
	"Private - Answers a <sequencedReadableCollection> of <Association> detailing the attributes that should appear on a image displaying the certificate details"

	^{'Serial no:' -> #serial.
		'Issued to:' -> #owner.
		'Email:' -> #details.
		'' -> #gap.
		'Purpose:' -> #purpose.
		'' -> #gap.
		'Validity:' -> #validityString.
		'Issued by:' -> #issuingAuthority}!

purpose
	"Answers the purpose of this certificate"

	^'This certificate ensures that the content is from a known individual and guarantees that it has not been modified since it was originally created.'! !

!MyOwnCertificate categoriesForMethods!
backgroundImageFile!constants!private! !
imageAttributes!drawing!helpers!private! !
purpose!accessing!public! !
!

!MyOwnCertificate class methodsFor!

info: certificateInfo 
	"Answers an instance of the receiver"

	| oaCert |
	oaCert := self rootCertificateClass new.
	^self 
		info: certificateInfo
		authority: oaCert
		authorityPrivateKey: oaCert class privateKey!

info: certificateInfo authority: aCertificationAuthorityCertificate authorityPrivateKey: privateKey
	"Answers an instance of the receiver"

	^(super publisherCertificate: aCertificationAuthorityCertificate) 
		info: certificateInfo privateKey: privateKey!

rootCertificateClass
	"This method must answer the class of the certification authority certificate"

	^MyOwnCertificationAuthorityCertificate!

serial: serial owner: owner details: details 
	"Answers a certificate definition given the above detail. This definition is presented in a Smalltalk
	workspace the contents of which contain the private/public keys for the certificate and the binary
	store bytes that can be used to regenerate the certificate itself.

	self serial: 'MY100002' owner: 'My Own Company Inc' details: 'security@company.com'
	"

	| keys info cert stream bytes validYears |
	keys := self signatureAlgorithm generateKeySetForGroup: self keyGroup.
	info := DolphinSureCertificateInfo 
				serial: serial
				owner: owner
				publicKey: keys second.
	info details: details.
	(validYears := self validYears) notNil ifTrue: [info expiry: (info issued addYears: validYears)].

	"The next line actually encodes the certificate so may take some time"
	cert := self info: info.

	"Now write code to rebuild the certificate from it's encoded bytes"
	stream := WriteStream on: String new.
	stream 
		display: ('"MyOwn DolphinSure certificate %1 for %2"

"Evaluate the following expressions in a workspace"

"Recreate the certificate from it''s bytes"
certificate := Object fromBinaryStoreBytes: ' 
				formatWith: serial
				with: owner).
	bytes := cert binaryStoreBytes.
	bytes printOn: stream.
	stream 
		display: ('.

"Show the certificate"
certificate show.

"Add it to your personal store"
DolphinSureCertificateStore myCertificates addCertificate: certificate.

"Retrieve it from your personal store"
(DolphinSureCertificateStore myCertificates atSerial: ''%1'' ifAbsent: []) show.

"If it is your default (first) certificate you can retrieve it like this..."
DolphinSureCertificateStore myCertificates default show.

' 
				formatWith: serial).
	stream 
		display: ('"THIS IS YOUR PRIVATE KEY=%1 (DO NOT DISCLOSE)"

"Sign data with your certificate"
trustedData := certificate sign: ''This is a secure message'' asByteArray privateKey: %1.
trustedData validData asString "Display it".
trustedData data at: 1 put: 0 "Change the data".
trustedData validData asString "Now try to Display it"."' 
				formatWith: keys first displayString).
	SmalltalkWorkspaceDocument show setDocumentData: stream contents.
	^cert!

validYears
	"Private - Answer the number of years that certificates of this class should be valid
	for by default. Nil indicates valid indefinitely."

	^1! !

!MyOwnCertificate class categoriesForMethods!
info:!instance creation!public! !
info:authority:authorityPrivateKey:!instance creation!public! !
rootCertificateClass!instance creation!public! !
serial:owner:details:!operations!public! !
validYears!constants!private! !
!

