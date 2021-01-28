"Filed out from Dolphin Smalltalk 7"!

UI.ProtectedProductSessionManager subclass: #'Security.Examples.ProtectedScribbleSessionManager'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Security.Examples.ProtectedScribbleSessionManager guid: (Core.GUID fromString: '{e5617c49-6f9a-4691-9d14-9d880bd4779c}')!
Security.Examples.ProtectedScribbleSessionManager comment: 'This is a version of the standard Scribble application that is protect by serial number. Try deploying this application and then entering the following serial number on startup:

	CWDH-UA9B-VS9Q-TAVQ-FP0C-YBSY-NZ5G-DB'!
!Security.Examples.ProtectedScribbleSessionManager categoriesForClass!Unclassified! !
!Security.Examples.ProtectedScribbleSessionManager methodsFor!

encryptedPackageNames
	"Answer the <Array> of packages whose classes are to be encrypted"

	^#('Scribble')!

productRegistrationKey
	"Answer the registry key name (under HKCU) where the license key for this product can be stored"

	^'Software\Object Arts\Protected Scribble\LicenseKey'!

serialNumberClass
	"Answer the class of the <ProtectedProductSerialNumber> used to encrypt the receiver"

	^MyCompanySerialNumber! !
!Security.Examples.ProtectedScribbleSessionManager categoriesFor: #encryptedPackageNames!constants!public! !
!Security.Examples.ProtectedScribbleSessionManager categoriesFor: #productRegistrationKey!constants!public! !
!Security.Examples.ProtectedScribbleSessionManager categoriesFor: #serialNumberClass!constants!public! !

!Security.Examples.ProtectedScribbleSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^Smalltalk.Scribble! !
!Security.Examples.ProtectedScribbleSessionManager class categoriesFor: #mainShellClass!constants!public! !

