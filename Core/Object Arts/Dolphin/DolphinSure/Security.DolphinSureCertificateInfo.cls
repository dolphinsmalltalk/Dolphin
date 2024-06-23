"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Security.DolphinSureCertificateInfo'
	instanceVariableNames: 'serial owner details issued expiry publicKey'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'ValidStbClasses'
				-> #(#{Core.Date} #{Core.AnsiString} #{Core.Utf8String} #{Core.LargeInteger} #{Core.SmallInteger} #{Security.DolphinSureCertificateInfo})
		}!

Security.DolphinSureCertificateInfo guid: (Core.GUID fromString: '{92dfd157-de8b-4c95-8ed4-fcc86403ef31}')!

Security.DolphinSureCertificateInfo comment: 'A DolphinSureCertificateInfo instance holds the unencoded data for a DolphinSureCertificate.

Instance Variables:
	serial		<readableString> uniquely identifying the certificate.
	owner		<readableString> identifying the certificate''s owner.
	details		<readableString> providing additional details about the owner.
	issued		<Date> when the certificate was issued.
	expiry		<Date> or nil when the certificate will expire.
	publicKeyCipher	<publicKeyCipher> of the certificate''s issuing authority.

'!

!Security.DolphinSureCertificateInfo categoriesForClass!Cryptography-Certificates! !

!Security.DolphinSureCertificateInfo methodsFor!

details
	"Answer the <readableString> contact details of the receiver"

	^details!

details: aString
	"Set the <readableString> contact details of the receiver"

	details := aString!

expiry
	"Answer the expiry <Date> of the receiver."

	^expiry!

expiry: aDate
	"Set the expiry <Date> of the receiver."

	expiry := aDate!

hasExpired
	"Answer true if the receiver has expired"

	self expiry isNil ifTrue: [^false].
	^(Date today between: self issued and: self expiry) not!

issued
	"Answer the issued <Date> of the receiver."

	^issued!

owner
	"Answer the <readableString> owner of the receiver"

	^owner!

printOn: aStream
	"Append a textual representation of the receiver to the <puttableStream> argument
	as a developer might want to see it."

	aStream 
		basicPrint: self;
		nextPut: $(;
		print: self serial;
		nextPut: $,;
		print: self owner;
		nextPut: $)!

publicKey
	"Answer the public key of the receiver."

	^publicKey!

serial
	"Answer the <readableString> serial number of the receiver"

	^serial!

serial: aStringSerialNo owner: aStringOwner publicKey: pkey
	"Private - Initialise the receiver"

	serial := aStringSerialNo.
	owner := aStringOwner.
	details := ''.
	issued := Date fromDays: 38328.
	publicKey := pkey
	!

validityString
	"Answers a <readableString> indicating the validity period for the receiver"

	| stream |
	stream := WriteStream on: String new.
	stream display: 'From '.
	self issued printOn: stream longPicture: false.
	stream display: ' '.
	self expiry notNil
		ifTrue: [ stream display: 'until '.
			self expiry printOn: stream longPicture: false.
			self hasExpired ifTrue: [
				stream nextPutAll: ' (EXPIRED)' ]]
		ifFalse: [ stream display: 'indefinitely'].
	^stream contents! !

!Security.DolphinSureCertificateInfo categoriesForMethods!
details!accessing!public! !
details:!accessing!public! !
expiry!accessing!public! !
expiry:!accessing!public! !
hasExpired!public!testing! !
issued!accessing!public! !
owner!accessing!public! !
printOn:!printing!public! !
publicKey!accessing!public! !
serial!accessing!public! !
serial:owner:publicKey:!initializing!private! !
validityString!accessing!public! !
!

!Security.DolphinSureCertificateInfo class methodsFor!

binaryReadFrom: aStream context: anObject
	"Answers an object read from its binary STB representation on aStream. Because STB is inherently an insecure format (loading objects can cause arbitrary code to be run) we must use a special STBInFiler (an STBValidatingInFiler) that will only load a restricted set of classes that we know to be passive."

	^(STBValidatingInFiler on: aStream
		validClasses: #(#{Core.Date} #{Core.AnsiString} #{Core.Utf8String} #{Core.LargeInteger} #{Core.SmallInteger} #{Security.DolphinSureCertificateInfo}))
		context: anObject;
		next!

new
	"Private - Use #serial:owner"

	self shouldNotImplement!

serial: aStringSerialNo owner: aStringOwner publicKey: pkey
	" Answers an instance of the receiver with aStringSerialNo, aStringOwner
	and a public key of pkey"

	^super new serial: aStringSerialNo owner: aStringOwner publicKey: pkey! !

!Security.DolphinSureCertificateInfo class categoriesForMethods!
binaryReadFrom:context:!binary filing!public! !
new!instance creation!private! !
serial:owner:publicKey:!instance creation!public! !
!

