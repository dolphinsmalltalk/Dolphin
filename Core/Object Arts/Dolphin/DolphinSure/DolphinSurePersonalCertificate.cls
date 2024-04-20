"Filed out from Dolphin Smalltalk"!

DolphinSureCertificate subclass: #DolphinSurePersonalCertificate
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DolphinSurePersonalCertificate guid: (GUID fromString: '{cd23937f-fc74-43fd-b678-bebeac42ee59}')!

DolphinSurePersonalCertificate comment: ''!

!DolphinSurePersonalCertificate categoriesForClass!Unclassified! !

!DolphinSurePersonalCertificate methodsFor!

purpose
	"Answers the purpose of this certificate"

	^'This certificate ensures that the content is from a known individual and guarantees that it has not been modified since it was originally created.'! !

!DolphinSurePersonalCertificate categoriesForMethods!
purpose!accessing!public! !
!

!DolphinSurePersonalCertificate class methodsFor!

validYears
	"Private - Answer the number of years that certificates of this class should be valid
	for by default. Nil indicates valid indefinitely."

	^1! !

!DolphinSurePersonalCertificate class categoriesForMethods!
validYears!constants!private! !
!

