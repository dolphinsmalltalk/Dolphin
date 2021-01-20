"Filed out from Dolphin Smalltalk 7"!

Object subclass: #DolphinSureCertificateInfo
	instanceVariableNames: 'serial owner details issued expiry publicKey'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DolphinSureCertificateInfo guid: (GUID fromString: '{92dfd157-de8b-4c95-8ed4-fcc86403ef31}')!
DolphinSureCertificateInfo comment: 'A DolphinSureCertificateInfo instance holds the unencoded data for a DolphinSureCertificate.

Instance Variables:
	serial		<readableString> uniquely identifying the certificate.
	owner		<readableString> identifying the certificate''s owner.
	details		<readableString> providing additional details about the owner.
	issued		<Date> when the certificate was issued.
	expiry		<Date> or nil when the certificate will expire.
	publicKeyCipher	<publicKeyCipher> of the certificate''s issuing authority.

'!
!DolphinSureCertificateInfo categoriesForClass!Cryptography-Certificates! !
!DolphinSureCertificateInfo methodsFor!

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
	issued := Date today.
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
!DolphinSureCertificateInfo categoriesFor: #details!accessing!public! !
!DolphinSureCertificateInfo categoriesFor: #details:!accessing!public! !
!DolphinSureCertificateInfo categoriesFor: #expiry!accessing!public! !
!DolphinSureCertificateInfo categoriesFor: #expiry:!accessing!public! !
!DolphinSureCertificateInfo categoriesFor: #hasExpired!public!testing! !
!DolphinSureCertificateInfo categoriesFor: #issued!accessing!public! !
!DolphinSureCertificateInfo categoriesFor: #owner!accessing!public! !
!DolphinSureCertificateInfo categoriesFor: #printOn:!printing!public! !
!DolphinSureCertificateInfo categoriesFor: #publicKey!accessing!public! !
!DolphinSureCertificateInfo categoriesFor: #serial!accessing!public! !
!DolphinSureCertificateInfo categoriesFor: #serial:owner:publicKey:!initializing!private! !
!DolphinSureCertificateInfo categoriesFor: #validityString!accessing!public! !

!DolphinSureCertificateInfo class methodsFor!

binaryReadFrom: aStream context: anObject 
	"Answers an instance of this class from its binary STB representation on aStream. Because STB is inherently an insecure format
	we must use an STBInFiler that especially guarded with a ValidatingClassLocator to that only expected, non-dangerous
	classes can be loaded from the STB stream."

	| inFiler validClasses |
	validClasses := (Set new)
				add: #Date;
				add: #Utf8String;
				add: #LargeInteger;
				add: #SmallInteger;
				add: self name;
				yourself.
	inFiler := (STBValidatingInFiler on: aStream)
				validationBlock: [:className | validClasses identityIncludes: className];
				context: anObject;
				yourself.
	^inFiler next!

new
	"Private - Use #serial:owner"

	self shouldNotImplement!

serial: aStringSerialNo owner: aStringOwner publicKey: pkey
	" Answers an instance of the receiver with aStringSerialNo, aStringOwner
	and a public key of pkey"

	^super new serial: aStringSerialNo owner: aStringOwner publicKey: pkey! !
!DolphinSureCertificateInfo class categoriesFor: #binaryReadFrom:context:!binary filing!public! !
!DolphinSureCertificateInfo class categoriesFor: #new!instance creation!private! !
!DolphinSureCertificateInfo class categoriesFor: #serial:owner:publicKey:!instance creation!public! !

