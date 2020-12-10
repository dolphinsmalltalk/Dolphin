"Filed out from Dolphin Smalltalk 7"!

UI.Folder subclass: #'Tools.PackageFolder'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.PackageFolder guid: (Core.GUID fromString: '{78425858-c3b5-4314-847a-772ff5268a84}')!
Tools.PackageFolder comment: ''!
!Tools.PackageFolder categoriesForClass!MVP-Models! !
!Tools.PackageFolder methodsFor!

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
!Tools.PackageFolder categoriesFor: #icon!constants!public! !
!Tools.PackageFolder categoriesFor: #isDolphinFolder!private!testing! !
!Tools.PackageFolder categoriesFor: #rootName!constants!private! !

!Tools.PackageFolder class methodsFor!

dolphinRoot
	"Answer an instance of the receiver representing the current dolphin package hierarchy"

	^self pathname: self dolphinRootPathname!

dolphinRootPathname
	^'core\'!

forPackage: aPackage 
	"Answer an instance of the receiver for the folder of aPackage"

	^self pathname: aPackage packageFolder! !
!Tools.PackageFolder class categoriesFor: #dolphinRoot!instance creation!public! !
!Tools.PackageFolder class categoriesFor: #dolphinRootPathname!constants!instance creation!public! !
!Tools.PackageFolder class categoriesFor: #forPackage:!instance creation!public! !

