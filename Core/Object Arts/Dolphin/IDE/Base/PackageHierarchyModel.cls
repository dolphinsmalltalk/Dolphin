"Filed out from Dolphin Smalltalk X6"!

FolderHierarchyModel subclass: #PackageHierarchyModel
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackageHierarchyModel guid: (GUID fromString: '{26DEA10B-1BC7-477F-A6B8-CA9452CE3D3E}')!
PackageHierarchyModel comment: 'PackageHierarchyModel is a <FolderHierarchyModel> specialized to represent the hierarchy of folders of installed packages.
'!
!PackageHierarchyModel categoriesForClass!Development!MVP-Models! !
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

