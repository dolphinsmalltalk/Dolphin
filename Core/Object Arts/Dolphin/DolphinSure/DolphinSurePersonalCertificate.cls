"Filed out from Dolphin Smalltalk 7"!

DolphinSureCertificate subclass: #DolphinSurePersonalCertificate
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DolphinSurePersonalCertificate guid: (GUID fromString: '{cd23937f-fc74-43fd-b678-bebeac42ee59}')!
DolphinSurePersonalCertificate comment: ''!
!DolphinSurePersonalCertificate categoriesForClass!Unclassified! !
!DolphinSurePersonalCertificate methodsFor!

backgroundImageFile
	"Private - Answers the resource name of the background image file
	for the receiver"

	^'Resources/DolphinSurePersonalCert.jpg'
!

imageAttributes
	"Private - Answers an OrderedCollection detailing the attributes that should
	appear on a image displaying the certificate details"

	^##(OrderedCollection new
		add: 'Serial no:' -> #serial;
		add: 'Issued to:' -> #owner;
		add: 'Details:' -> #details;
		add: '' -> #gap;
		add: 'Purpose:' -> #purpose;
		add: '' -> #gap;
		add: 'Validity:' -> #validityString;
		add: 'Issued by:' -> #issuingAuthority;
		yourself)!

purpose
	"Answers the purpose of this certificate"

	^'This certificate ensures that the content is from a known individual and guarantees that it has not been modified since it was originally created.'! !
!DolphinSurePersonalCertificate categoriesFor: #backgroundImageFile!constants!private! !
!DolphinSurePersonalCertificate categoriesFor: #imageAttributes!drawing!helpers!private! !
!DolphinSurePersonalCertificate categoriesFor: #purpose!accessing!public! !

!DolphinSurePersonalCertificate class methodsFor!

validYears
	"Private - Answer the number of years that certificates of this class should be valid
	for by default. Nil indicates valid indefinitely."

	^1! !
!DolphinSurePersonalCertificate class categoriesFor: #validYears!constants!private! !

