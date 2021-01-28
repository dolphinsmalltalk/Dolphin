"Filed out from Dolphin Smalltalk 7"!

Security.DolphinSureTrustedData subclass: #'Security.DolphinSureCertificate'
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

backgroundImageFile
	"Private - Answers the resource name of the background image file
	for the receiver"

	^'Resources/DolphinSureCert.jpg'
!

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

gap	
	"Private - Answers a string to leave a gap"

	^' '!

hasExpired
	"Answer true if the receiver has expired"

	| info |
	info := self info.
	^Date today between: info issued and: info expiry!

imageAttributes
	"Private - Answers an OrderedCollection detailing the attributes that should
	appear on a image displaying the certificate details"

	^##(OrderedCollection new
		add: 'Serial no:' -> #serial;
		add: 'Publisher:' -> #owner;
		add: 'Details:' -> #details;
		add: '' -> #gap;
		add: 'Purpose:' -> #purpose;
		add: '' -> #gap;
		add: 'Validity:' -> #validityString;
		add: 'Issued by:' -> #issuingAuthority;
		yourself)!

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
!Security.DolphinSureCertificate categoriesFor: #=!comparing!public! !
!Security.DolphinSureCertificate categoriesFor: #backgroundImageFile!constants!private! !
!Security.DolphinSureCertificate categoriesFor: #beNotPermanentlyTrusted!accessing!public!trust! !
!Security.DolphinSureCertificate categoriesFor: #beNotTemporarilyTrusted!accessing!public!trust! !
!Security.DolphinSureCertificate categoriesFor: #beNotTrusted!accessing!public!trust! !
!Security.DolphinSureCertificate categoriesFor: #bePermanentlyTrusted!accessing!public!trust! !
!Security.DolphinSureCertificate categoriesFor: #beTemporarilyTrusted!accessing!public!trust! !
!Security.DolphinSureCertificate categoriesFor: #canBePermanentlyTrusted!public!testing!trust! !
!Security.DolphinSureCertificate categoriesFor: #confirmTrustFor:!operations!public!trust! !
!Security.DolphinSureCertificate categoriesFor: #details!accessing!public! !
!Security.DolphinSureCertificate categoriesFor: #displayOn:!printing!public! !
!Security.DolphinSureCertificate categoriesFor: #gap!drawing!helpers!private! !
!Security.DolphinSureCertificate categoriesFor: #hasExpired!public!testing! !
!Security.DolphinSureCertificate categoriesFor: #imageAttributes!drawing!helpers!private! !
!Security.DolphinSureCertificate categoriesFor: #info!accessing!public! !
!Security.DolphinSureCertificate categoriesFor: #info:privateKey:!accessing!private! !
!Security.DolphinSureCertificate categoriesFor: #isPermanentlyTrusted!public!testing!trust! !
!Security.DolphinSureCertificate categoriesFor: #issuingAuthority!accessing!public! !
!Security.DolphinSureCertificate categoriesFor: #isTemporarilyTrusted!public!testing!trust! !
!Security.DolphinSureCertificate categoriesFor: #isTrusted!public!testing!trust! !
!Security.DolphinSureCertificate categoriesFor: #owner!accessing!public! !
!Security.DolphinSureCertificate categoriesFor: #printOn:!printing!public! !
!Security.DolphinSureCertificate categoriesFor: #publicKey!accessing!public! !
!Security.DolphinSureCertificate categoriesFor: #purpose!accessing!public! !
!Security.DolphinSureCertificate categoriesFor: #serial!accessing!public! !
!Security.DolphinSureCertificate categoriesFor: #sign:description:privateKey:!operations!public! !
!Security.DolphinSureCertificate categoriesFor: #sign:privateKey:!operations!public! !
!Security.DolphinSureCertificate categoriesFor: #validityString!helpers!private! !

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
!Security.DolphinSureCertificate class categoriesFor: #icon!constants!development!public! !
!Security.DolphinSureCertificate class categoriesFor: #info:authority:authorityPrivateKey:!instance creation!public! !
!Security.DolphinSureCertificate class categoriesFor: #initialize!initializing!private! !
!Security.DolphinSureCertificate class categoriesFor: #myDefault!instance creation!public! !
!Security.DolphinSureCertificate class categoriesFor: #new!instance creation!private! !
!Security.DolphinSureCertificate class categoriesFor: #publisherCertificate:privateKey:!instance creation!private! !
!Security.DolphinSureCertificate class categoriesFor: #untrustedContentWarning!constants!public! !

