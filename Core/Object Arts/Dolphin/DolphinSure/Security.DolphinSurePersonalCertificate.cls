"Filed out from Dolphin Smalltalk"!

Security.DolphinSureCertificate
	subclass: #'Security.DolphinSurePersonalCertificate'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Security.DolphinSurePersonalCertificate guid: (Core.GUID fromString: '{cd23937f-fc74-43fd-b678-bebeac42ee59}')!

Security.DolphinSurePersonalCertificate comment: ''!

!Security.DolphinSurePersonalCertificate methodsFor!

purpose
	"Answers the purpose of this certificate"

	^'This certificate ensures that the content is from a known individual and guarantees that it has not been modified since it was originally created.'! !

!Security.DolphinSurePersonalCertificate categoriesForMethods!
purpose!accessing!public! !
!

!Security.DolphinSurePersonalCertificate class methodsFor!

validYears
	"Private - Answer the number of years that certificates of this class should be valid
	for by default. Nil indicates valid indefinitely."

	^1! !

!Security.DolphinSurePersonalCertificate class categoriesForMethods!
validYears!constants!private! !
!

