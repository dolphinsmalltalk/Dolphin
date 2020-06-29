"Filed out from Dolphin Smalltalk 7"!

DolphinSureCertificate subclass: #DolphinSureCertificationAuthorityCertificate
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DolphinSureCertificationAuthorityCertificate guid: (GUID fromString: '{43a98823-a087-4695-b184-d31958f81869}')!
DolphinSureCertificationAuthorityCertificate comment: 'A DolphinSureCertificationAuthorityCertificate instance is used to represent a certificate that can be used by a DolphinSure certifying authority to issue standard DolphinSureCertificates for publishers.'!
!DolphinSureCertificationAuthorityCertificate categoriesForClass!Cryptography-Certificates! !
!DolphinSureCertificationAuthorityCertificate methodsFor!

imageAttributes
	"Private - Answers an OrderedCollection detailing the attributes that should
	appear on a image displaying the certificate details"

	^##(OrderedCollection new
		add: 'Serial no:' -> #serial;
		add: 'Certifying Authority:' -> #owner;
		add: 'Details:' -> #details;
		add: '' -> #gap;
		add: 'Purpose:' -> #purpose;
		add: '' -> #gap;
		add: 'Validity:' -> #validityString;
		add: 'Issued by:' -> #issuingAuthority;
		yourself)!

purpose
	"Answers the purpose of this certificate"

	^'This certificate belongs to a DolphinSure certifying authority and guarantees that the owner has the right to issue certificates to DolphinSure publishers.'! !
!DolphinSureCertificationAuthorityCertificate categoriesFor: #imageAttributes!accessing!private! !
!DolphinSureCertificationAuthorityCertificate categoriesFor: #purpose!accessing!public! !

