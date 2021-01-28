"Filed out from Dolphin Smalltalk 7"!

Core.Error subclass: #'Security.TrustedDataError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Security.TrustedDataError guid: (Core.GUID fromString: '{122331e1-d05e-4caa-ac3d-34575a2e2d9f}')!
Security.TrustedDataError comment: 'A TrustedDataError is signalled if an instance of DolphinSureTrustedData cannot correctly decode its contents.  This is probably an indication that the trusted data has been tampered with in transit.'!
!Security.TrustedDataError categoriesForClass!Cryptography-Support! !
!Security.TrustedDataError methodsFor!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'It was not possible to decode some trusted signed data. The data is either corrupt or has been tampered with.'
! !
!Security.TrustedDataError categoriesFor: #_descriptionFormat!displaying!public! !

