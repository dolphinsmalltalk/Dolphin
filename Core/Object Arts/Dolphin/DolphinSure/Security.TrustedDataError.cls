"Filed out from Dolphin Smalltalk 7"!

Error subclass: #TrustedDataError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
TrustedDataError guid: (GUID fromString: '{122331e1-d05e-4caa-ac3d-34575a2e2d9f}')!
TrustedDataError comment: 'A TrustedDataError is signalled if an instance of DolphinSureTrustedData cannot correctly decode its contents.  This is probably an indication that the trusted data has been tampered with in transit.'!
!TrustedDataError categoriesForClass!Cryptography-Support! !
!TrustedDataError methodsFor!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'It was not possible to decode some trusted signed data. The data is either corrupt or has been tampered with.'
! !
!TrustedDataError categoriesFor: #_descriptionFormat!displaying!public! !

