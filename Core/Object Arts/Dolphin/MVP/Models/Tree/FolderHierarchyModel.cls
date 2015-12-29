"Filed out from Dolphin Smalltalk X6"!

TreeModel subclass: #FolderHierarchyModel
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FolderHierarchyModel guid: (GUID fromString: '{2DFE6611-349C-497A-969B-CC0AEA7ECC70}')!
FolderHierarchyModel comment: 'FolderHierarchyModel is a specialized <TreeModel> that holds a directory hierarchy, with nodes representing each directory/folder in the hierarchy. The nodes are maintained in sorted order.
'!
!FolderHierarchyModel categoriesForClass!MVP-Models! !
!FolderHierarchyModel methodsFor!

addFolder: aString 
	"Add the hierarchy of folders in the <readableString> path argument to the receiver."

	| parent newFolder |
	newFolder := self folderClass pathname: aString.
	(aString isEmpty or: [File isRootPath: aString]) 
		ifFalse: 
			[parent := newFolder parent.
			(self includes: parent) ifFalse: [self addFolder: parent pathname]].
	self add: newFolder asChildOf: parent!

folderClass
	^Folder!

newNode: anObject 
	^(super newNode: anObject)
		children: (SortedCollection sortBlock: [:x :y | x object <= y object]);
		yourself! !
!FolderHierarchyModel categoriesFor: #addFolder:!adding!public! !
!FolderHierarchyModel categoriesFor: #folderClass!operations!private! !
!FolderHierarchyModel categoriesFor: #newNode:!adding!private! !

!FolderHierarchyModel class methodsFor!

defaultSearchPolicy
	^SearchPolicy equality! !
!FolderHierarchyModel class categoriesFor: #defaultSearchPolicy!constants!public! !

