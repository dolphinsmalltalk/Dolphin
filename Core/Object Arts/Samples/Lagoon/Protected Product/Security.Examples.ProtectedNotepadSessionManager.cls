"Filed out from Dolphin Smalltalk 7"!

UI.ProtectedProductSessionManager subclass: #'Security.Examples.ProtectedNotepadSessionManager'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Security.Examples.ProtectedNotepadSessionManager guid: (Core.GUID fromString: '{e44c24a0-f742-4831-91ac-b316bfcf5c1c}')!
Security.Examples.ProtectedNotepadSessionManager comment: 'This is a version of the standard (Dolphin) Notepad application that is protect by serial number using asymmetric encryption. Try deploying this application and then entering the following serial number on startup:

	29PS-EV22-WA3C-PT7S-US87-FBWU-U1PM-D80V-7VAL-RSJQ-YH5C-THJV-KNWD-8VKG-AWRY-Q2L0-Y3CN-A3LK-MQEX-S6MJ-XB38-BWUP-VQYH-EBWN-13HY-AAT5-YCUK-8XMN-GHTJ-SHTG-YJ29-K7SE-MNRJ-1HJQ-3ADX-E8Q4-PKS8-958/DLJP-FY8E-VMYE-58GX-VKQ1-LVQF-NKU2-03YK-NPAD-L0NC-8ALE-VNC3-YXCR-7R8S-9U1S-AZWG-REJ7-EXP2-E8GP-AG73-UAVH-SMKV-BF3N-VQLD-2K1F-G3AA-KFMZ-3M3P-YKPE-X1LY-D987-3YKU-HCBC-BX68-PSVK-5QDV-MP97-9VL

Which is -- of course -- too long to be practical.  TODO: change this example to use a key file.'!
!Security.Examples.ProtectedNotepadSessionManager categoriesForClass!Unclassified! !
!Security.Examples.ProtectedNotepadSessionManager methodsFor!

encryptedPackageNames
	"Answer the <Array> of packages whose classes are to be encrypted"

	^#('Notepad')!

productRegistrationKey
	"Answer the registry key name (under HKCU) where the license key for this product can be stored"

	^'Software\Object Arts\Protected Notepad\LicenseKey'!

serialNumberClass
	"Answer the class of the <ProtectedProductSerialNumber> used to encrypt the receiver"

	^AnotherCompanySerialNumber! !
!Security.Examples.ProtectedNotepadSessionManager categoriesFor: #encryptedPackageNames!constants!public! !
!Security.Examples.ProtectedNotepadSessionManager categoriesFor: #productRegistrationKey!constants!public! !
!Security.Examples.ProtectedNotepadSessionManager categoriesFor: #serialNumberClass!constants!public! !

!Security.Examples.ProtectedNotepadSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^Smalltalk.Notepad! !
!Security.Examples.ProtectedNotepadSessionManager class categoriesFor: #mainShellClass!constants!public! !

