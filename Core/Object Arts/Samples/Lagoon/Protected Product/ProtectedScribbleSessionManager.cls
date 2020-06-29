"Filed out from Dolphin Smalltalk 7"!

ProtectedProductSessionManager subclass: #ProtectedScribbleSessionManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ProtectedScribbleSessionManager guid: (GUID fromString: '{e5617c49-6f9a-4691-9d14-9d880bd4779c}')!
ProtectedScribbleSessionManager comment: 'This is a version of the standard Scribble application that is protect by serial number. Try deploying this application and then entering the following serial number on startup:

	CWDH-UA9B-VS9Q-TAVQ-FP0C-YBSY-NZ5G-DB'!
!ProtectedScribbleSessionManager categoriesForClass!Unclassified! !
!ProtectedScribbleSessionManager methodsFor!

encryptedPackageNames
	"Answer the <Array> of packages whose classes are to be encrypted"

	^#('Scribble')!

productRegistrationKey
	"Answer the registry key name (under HKCU) where the license key for this product can be stored"

	^'Software\Object Arts\Protected Scribble\LicenseKey'!

serialNumberClass
	"Answer the class of the <ProtectedProductSerialNumber> used to encrypt the receiver"

	^MyCompanySerialNumber! !
!ProtectedScribbleSessionManager categoriesFor: #encryptedPackageNames!constants!public! !
!ProtectedScribbleSessionManager categoriesFor: #productRegistrationKey!constants!public! !
!ProtectedScribbleSessionManager categoriesFor: #serialNumberClass!constants!public! !

!ProtectedScribbleSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^Scribble! !
!ProtectedScribbleSessionManager class categoriesFor: #mainShellClass!constants!public! !

