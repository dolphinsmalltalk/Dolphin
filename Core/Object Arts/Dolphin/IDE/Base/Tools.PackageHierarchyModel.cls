"Filed out from Dolphin Smalltalk 7"!

UI.FolderHierarchyModel subclass: #'Tools.PackageHierarchyModel'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.PackageHierarchyModel guid: (Core.GUID fromString: '{26dea10b-1bc7-477f-a6b8-ca9452ce3d3e}')!
Tools.PackageHierarchyModel comment: 'PackageHierarchyModel is a <FolderHierarchyModel> specialized to represent the hierarchy of folders of installed packages.
'!
!Tools.PackageHierarchyModel categoriesForClass!MVP-Models! !
!Tools.PackageHierarchyModel methodsFor!

addPackage: aPackage 
	"Private - Add a the hierarchy of folders leading to the specified <Package> to the receiver."

	self addFolder: aPackage packageFolder!

buildTree
	self noEventsDo: 
			[Package manager packages do: [:each | self addPackage: each].
			self addPackage: Package uncommitted].
	self refreshTree: nil!

folderClass
	^PackageFolder!

initialize
	super initialize.
	Package manager 
		when: #loadedChanged
		send: #refresh
		to: self.
	"self noEventsDo: ["self buildTree"]"!

refresh
	"Private - Clear the receiver's existing contents and rebuild from the currently installed set
	of <Package>s."

	self reset.
	self buildTree! !
!Tools.PackageHierarchyModel categoriesFor: #addPackage:!adding!private! !
!Tools.PackageHierarchyModel categoriesFor: #buildTree!private!updating! !
!Tools.PackageHierarchyModel categoriesFor: #folderClass!constants!private! !
!Tools.PackageHierarchyModel categoriesFor: #initialize!initializing!public! !
!Tools.PackageHierarchyModel categoriesFor: #refresh!private!updating! !

