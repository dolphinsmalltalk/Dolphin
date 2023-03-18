"Filed out from Dolphin Smalltalk"!

UI.Folder
	subclass: #'Tools.PackageFolder'
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

	^pathname beginsWith: self class dolphinRootPathname ignoreCase: true!

rootName
	"Private - Answer the name to use for the folder at the root of the current image hierarchy"

	^'$'! !
!Tools.PackageFolder categoriesForMethods!
icon!constants!public! !
isDolphinFolder!private!testing! !
rootName!constants!private! !
!

!Tools.PackageFolder class methodsFor!

dolphinRoot
	"Answer an instance of the receiver representing the current dolphin package hierarchy"

	^self pathname: self dolphinRootPathname!

dolphinRootPathname
	^'Core\'!

forPackage: aPackage 
	"Answer an instance of the receiver for the folder of aPackage"

	^self pathname: aPackage packageFolder! !
!Tools.PackageFolder class categoriesForMethods!
dolphinRoot!instance creation!public! !
dolphinRootPathname!constants!instance creation!public! !
forPackage:!instance creation!public! !
!

