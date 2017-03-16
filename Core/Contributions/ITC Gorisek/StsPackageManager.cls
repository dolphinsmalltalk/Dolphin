"Filed out from Dolphin Smalltalk 7"!

PackageManager subclass: #StsPackageManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsPackageManager guid: (GUID fromString: '{91a522ef-8710-4749-9ac6-42d8e1ba1206}')!
StsPackageManager comment: ''!
!StsPackageManager categoriesForClass!Development! !
!StsPackageManager methodsFor!

basicInstall: aPackage 
	(self sourceControl)
		markPackageAsChanged: aPackage;
		ignoreCompilerWhile: [aPackage load]!

basicUninstall: aPackage 
	"Private - Remove aPackage from the receivers loaded packages.
	All the packages owned objects are removed from the system.
	Answer aPackage."

	self sourceControl markPackageAsChanged: aPackage.
	super basicUninstall: aPackage!

sourceControl
	^StsManager current!

versionPackageIfRequired: aPackage 
	"If we are connected to a repository and aPackage is included in the repository then prompt to version it"

	self sourceControl isConnected ifFalse: [^self].
	(Package manager sourceControl getAllPackageNames includes: aPackage name) ifFalse: [^self].
	self sourceControl versionPackage: aPackage! !
!StsPackageManager categoriesFor: #basicInstall:!operations!private! !
!StsPackageManager categoriesFor: #basicUninstall:!private!removing! !
!StsPackageManager categoriesFor: #sourceControl!accessing!private! !
!StsPackageManager categoriesFor: #versionPackageIfRequired:!public! !

!StsPackageManager class methodsFor!

initialize
	"
	self initialize
	"

	self current becomeA: self.
	SmalltalkSystem current addSystemFolderIcon: (SmalltalkSystemFolder 
				icon: (Icon fromId: 'SOURCETRACKINGTOOLSFOLDER.ICO')
				description: 'Source Tracking Tools'
				helpId: 10608)!

isSafeToEncryptWithProductProtection
	"Answer whether it is save to encrypt the receiver's methods as part of the
	the deployment of a Protected Product application"

	^false!

uninitialize
	"
	self uninitialize
	"

	Current ifNotNil: [:singleton | singleton becomeA: PackageManager].
	SmalltalkSystem current 
		removeSystemFolderIcon: Smalltalk developmentSystem sourceTrackingToolsFolder! !
!StsPackageManager class categoriesFor: #initialize!private! !
!StsPackageManager class categoriesFor: #isSafeToEncryptWithProductProtection!constants!public!testing! !
!StsPackageManager class categoriesFor: #uninitialize!class hierarchy-removing!private! !

