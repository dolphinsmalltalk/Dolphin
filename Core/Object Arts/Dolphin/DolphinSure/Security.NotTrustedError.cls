"Filed out from Dolphin Smalltalk 7"!

Core.Error subclass: #'Security.NotTrustedError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Security.NotTrustedError guid: (Core.GUID fromString: '{c937ff99-3a3c-40e8-aa56-8a6f893454d0}')!
Security.NotTrustedError comment: 'A NotTrustedError is signalled to indicate when the load of a binary class file has been prevented by the end-user due to a lack of trust in the publisher of the class. It is either signalled when a digital certificate for a signed class has been refused (in SignedClassStub>>reifyClassUsing:) or when an unsigned class is being loaded and the standard NotSignedCertificate has been refused instead.

Normal policy is to let the error propagate unimpeded and, either bring up a walkback in the development system, or display a warning MessageBox in a run-time system.  However, one might consider trapping this error and performing some other action when an untrusted class load is refused.'!
!Security.NotTrustedError categoriesForClass!System-Binary class loading! !
!Security.NotTrustedError methodsFor!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'The use of the untrusted content (%1) has been prevented.'
! !
!Security.NotTrustedError categoriesFor: #_descriptionFormat!displaying!public! !

