"Filed out from Dolphin Smalltalk 7"!

FolderHierarchyModel subclass: #PackageHierarchyModel
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PackageHierarchyModel guid: (GUID fromString: '{26dea10b-1bc7-477f-a6b8-ca9452ce3d3e}')!
PackageHierarchyModel comment: 'PackageHierarchyModel is a <FolderHierarchyModel> specialized to represent the hierarchy of folders of installed packages.
'!
!PackageHierarchyModel categoriesForClass!MVP-Models! !
!PackageHierarchyModel methodsFor!

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
!PackageHierarchyModel categoriesFor: #addPackage:!adding!private! !
!PackageHierarchyModel categoriesFor: #buildTree!private!updating! !
!PackageHierarchyModel categoriesFor: #folderClass!constants!private! !
!PackageHierarchyModel categoriesFor: #initialize!initializing!public! !
!PackageHierarchyModel categoriesFor: #refresh!private!updating! !

