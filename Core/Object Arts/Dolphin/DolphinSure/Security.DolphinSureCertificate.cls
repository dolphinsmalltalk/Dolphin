﻿"Filed out from Dolphin Smalltalk"!

Security.DolphinSureTrustedData
	subclass: #'Security.DolphinSureCertificate'
	instanceVariableNames: ''
	classVariableNames: 'UntrustedContentWarning'
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!

Security.DolphinSureCertificate guid: (Core.GUID fromString: '{e143e2b9-bce4-4c55-b0f7-7060dd84d239}')!

Security.DolphinSureCertificate comment: 'A DolphinSureCertificate can be used when signing a piece of DolphinSureTrustedData.  It can be used to guarantee that the trusted data is from a particular publisher and because it contains a public key that is used to encode the data one can feel confident that the data has not been modified in transit. Note that, a DolphinSureCertificate is also trusted data itself.  This prevents an attacker from forging the certificate.

If you wish to be able to make use of DolphinSureTrustedData within your applications, either directly or when you wish to digitally sign Dolphin web applets, then you will need to apply for a publisher''s certificate from Object Arts or create one yourself.'!

!Security.DolphinSureCertificate categoriesForClass!Cryptography-Certificates! !

!Security.DolphinSureCertificate methodsFor!

= anObject
	"Answer whether the receiver is considered equivalent to the argument
	anObject. We use the non-evaluating conjunction to prevent anObject
	being sent messages it might not understand."

	^self species == anObject species and: [self publicKey = anObject publicKey]!

beNotPermanentlyTrusted
	"Sets the receiver to be untrusted in the permanent store"

	DolphinSureCertificateStore permanentTrust removeCertificate: self ifAbsent: []!

beNotTemporarilyTrusted
	"Sets the receiver to be untrusted in the temporary store"

	DolphinSureCertificateStore temporaryTrust removeCertificate: self ifAbsent: []!

beNotTrusted
	"Sets the receiver to be untrusted by removing it from the trust stores"

	self beNotTemporarilyTrusted; beNotPermanentlyTrusted.
!

bePermanentlyTrusted
	"Sets the receiver to be trusted only for this session by adding it to the session trust store"

	DolphinSureCertificateStore permanentTrust addCertificate: self!

beTemporarilyTrusted
	"Sets the receiver to be trusted only for this session by adding it to the session trust store"

	DolphinSureCertificateStore temporaryTrust addCertificate: self!

canBePermanentlyTrusted
	"Answer true if the receiver can be added to the permanent trust store."

	^true!

confirmTrustFor: aStringDescription
	"Prompts to confirm with the user whether the content with aStringDescription
	should be trusted under the juridiction of the receiver. If the user decides to
	trust this certificate then it will be entered into the local or global trust store
	as appropriate. Answers true if the certificate was trusted"

	self isTrusted ifTrue: [^true].
	#todo.	"Don't pop a dialog here, just raise the warning. Leave it up to the client code to decide how to handle the warning"
	#{UI.DolphinSureTrustWarning}
		ifDefined: [:dialog | dialog showModalOn: self description: aStringDescription]
		ifNotDefined: [UntrustedContentWarning signal: aStringDescription with: self].
	^self isTrusted!

details
	"Answers the details of the receiver"

	^self info details
	 !

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	| info |
	info := self info.
	aPuttableStream
		display: info owner;
		nextPutAll: ' (';
		display: info serial;
		nextPut: $)!

hasExpired
	"Answer true if the receiver has expired"

	| info |
	info := self info.
	^Date today between: info issued and: info expiry!

info
	"Answers the decoded information for the receiver"

	^DolphinSureCertificateInfo fromBinaryStoreBytes: self data!

info: aDolphinSureCertificateInfo privateKey: privateKey
	"Private - Set the encoded information held by the receiver to aDolphinSureCertificateInfo"

	self data: aDolphinSureCertificateInfo binaryStoreBytes 
		description: self class name asString 
			privateKey: privateKey
	 !

isPermanentlyTrusted
	"Answer true if the receiver is currently permanently trusted; that is, it is contained
	within one of our trust stores"

	^DolphinSureCertificateStore permanentTrust includesCertificate: self!

issuingAuthority
	"Answers the name of the issuing authority of the receiver"

	^self publisher owner!

isTemporarilyTrusted
	"Answer true if the receiver is currently temporariliy trusted"

	^DolphinSureCertificateStore temporaryTrust includesCertificate: self!

isTrusted
	"Answer true if the receiver is currently trusted; that is, it is contained
	within one of our trust stores"

	^(self isTemporarilyTrusted ) or: [self isPermanentlyTrusted]

	!

owner
	"Answers the owner of the receiver"

	^self info owner
	 !

printOn: aStream
	"Append a textual representation of the receiver to the <puttableStream> argument
	as a developer might want to see it."

	| info |
	info := self info.
	aStream 
		basicPrint: self;
		nextPut: $(;
		print: info serial;
		nextPut: $,;
		print: info owner;
		nextPut: $)!

publicKey
	"Answer the public key of the receiver"

	^self info publicKey!

purpose
	"Answers the purpose of this certificate"

	^'This certificate ensures that the content is from a known publisher and guarantees that it has not been modified since it was originally created.'!

serial
	"Answers the serial number of the receiver"

	^self info serial
	 !

sign: aByteArray description: aStringDescription privateKey: privateKey
	"Signs the data in aByteArray using the receiver and it's privateKey. Answers an
	instance of DolphinSureTrustedData. If an error occurs it is likely that the private
	key does not match that for the certificate."

	^(DolphinSureTrustedData publisherCertificate: self)
		data: aByteArray
		description: aStringDescription
		privateKey: privateKey!

sign: aByteArray privateKey: privateKey
	"Signs the data in aByteArray using the receiver and it's privateKey. Answers an
	instance of DolphinSureTrustedData. If an error occurs it is likely that the private
	key does not match that for the certificate."

	^self sign: aByteArray description: '' privateKey: privateKey!

validityString
	"Private - Answers the validity information of the receiver"

	^self info validityString
	 ! !

!Security.DolphinSureCertificate categoriesForMethods!
=!comparing!public! !
beNotPermanentlyTrusted!accessing!public!trust! !
beNotTemporarilyTrusted!accessing!public!trust! !
beNotTrusted!accessing!public!trust! !
bePermanentlyTrusted!accessing!public!trust! !
beTemporarilyTrusted!accessing!public!trust! !
canBePermanentlyTrusted!public!testing!trust! !
confirmTrustFor:!operations!public!trust! !
details!accessing!public! !
displayOn:!printing!public! !
hasExpired!public!testing! !
info!accessing!public! !
info:privateKey:!accessing!private! !
isPermanentlyTrusted!public!testing!trust! !
issuingAuthority!accessing!public! !
isTemporarilyTrusted!public!testing!trust! !
isTrusted!public!testing!trust! !
owner!accessing!public! !
printOn:!printing!public! !
publicKey!accessing!public! !
purpose!accessing!public! !
serial!accessing!public! !
sign:description:privateKey:!operations!public! !
sign:privateKey:!operations!public! !
validityString!helpers!private! !
!

!Security.DolphinSureCertificate class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

info: certificateInfo authority: aCertificationAuthorityCertificate authorityPrivateKey: privateKey
	"Answers an instance of the receiver"

	^(super publisherCertificate: aCertificationAuthorityCertificate) 
		info: certificateInfo privateKey: privateKey!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	UntrustedContentWarning := WarningSignal description: 'Untrusted Content %1'!

myDefault
	"Answers a default instance of the receiver loaded from the My Certificates store"

	^DolphinSureCertificateStore myCertificates default!

new
	"Private - Use #info:"

	self shouldNotImplement!

publisherCertificate: certificate privateKey: privKey
	"Private - Use #info:"

	self shouldNotImplement
!

untrustedContentWarning
	"Answer an <exceptionSelector> that can be used to trap untrusted content warnings raised
	by the receiver."

	UntrustedContentWarning := WarningSignal description: 'Untrusted Content %1'! !

!Security.DolphinSureCertificate class categoriesForMethods!
icon!constants!development!public! !
info:authority:authorityPrivateKey:!instance creation!public! !
initialize!initializing!private! !
myDefault!instance creation!public! !
new!instance creation!private! !
publisherCertificate:privateKey:!instance creation!private! !
untrustedContentWarning!constants!public! !
!

