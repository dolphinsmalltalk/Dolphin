"Filed out from Dolphin Smalltalk 7"!

UI.TreeModel subclass: #'UI.FolderHierarchyModel'
	instanceVariableNames: ''
	classVariableNames: 'NodeSortAlgorithm'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.FolderHierarchyModel guid: (Core.GUID fromString: '{2dfe6611-349c-497a-969b-cc0aea7ecc70}')!
UI.FolderHierarchyModel comment: 'FolderHierarchyModel is a specialized <TreeModel> that holds a directory hierarchy, with nodes representing each directory/folder in the hierarchy. The nodes are maintained in sorted order.
'!
!UI.FolderHierarchyModel categoriesForClass!MVP-Models! !
!UI.FolderHierarchyModel methodsFor!

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
		children: (SortedCollection sortAlgorithm: NodeSortAlgorithm);
		yourself! !
!UI.FolderHierarchyModel categoriesFor: #addFolder:!adding!public! !
!UI.FolderHierarchyModel categoriesFor: #folderClass!operations!private! !
!UI.FolderHierarchyModel categoriesFor: #newNode:!adding!private! !

!UI.FolderHierarchyModel class methodsFor!

defaultSearchPolicy
	^SearchPolicy equality!

initialize
	self addClassConstant: 'NodeSortAlgorithm'
		value: ((SortedCollection defaultSortAlgorithmClass newSortBlock: [:x :y | x object <= y object])
				isImmutable: true;
				yourself)! !
!UI.FolderHierarchyModel class categoriesFor: #defaultSearchPolicy!constants!public! !
!UI.FolderHierarchyModel class categoriesFor: #initialize!development!initializing!private! !

