"Filed out from Dolphin Smalltalk"!

Folder subclass: #PackageFolder
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackageFolder guid: (GUID fromString: '{78425858-c3b5-4314-847a-772ff5268a84}')!
PackageFolder comment: ''!
!PackageFolder categoriesForClass!MVP-Models! !
!PackageFolder methodsFor!

icon
	"Answer an <Icon> to use when representing the receiver"

	^self isDolphinFolder 
		ifTrue: [Icon fromId: 'DOLPHINPACKAGEFOLDER.ICO']
		ifFalse: [super icon]!

isDolphinFolder
	"Private - Answer true if the receiver represents a Dolphin base system package folder"

	^self canonicalPath beginsWith: self class dolphinRootPathname!

rootName
	"Private - Answer the name to use for the folder at the root of the current image hierarchy"

	^'$'! !
!PackageFolder categoriesForMethods!
icon!constants!public! !
isDolphinFolder!private!testing! !
rootName!constants!private! !
!

!PackageFolder class methodsFor!

dolphinRoot
	"Answer an instance of the receiver representing the current dolphin package hierarchy"

	^self pathname: self dolphinRootPathname!

dolphinRootPathname
	^'core\'!

forPackage: aPackage 
	"Answer an instance of the receiver for the folder of aPackage"

	^self pathname: aPackage packageFolder! !
!PackageFolder class categoriesForMethods!
dolphinRoot!instance creation!public! !
dolphinRootPathname!constants!instance creation!public! !
forPackage:!instance creation!public! !
!

