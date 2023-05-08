"Filed out from Dolphin Smalltalk"!

UI.TreeModel
	subclass: #'UI.FolderHierarchyModel'
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

add: aFolder
	"Add the <Folder> argument to the model, recursively including any of its parent folders necessary to construct a path to a root folder."

	| parent |
	parent := aFolder parent.
	(parent isNil or: [self includes: parent]) ifFalse: [self add: parent].
	self add: aFolder asChildOf: parent!

addFolder: aString
	"Add the hierarchy of folders in the <readableString> path argument to the receiver."

	self add: (self folderClass pathname: aString)!

folderClass
	^Folder!

newNode: anObject
	^(super newNode: anObject)
		children: (SortedCollection sortAlgorithm: NodeSortAlgorithm);
		yourself! !
!UI.FolderHierarchyModel categoriesForMethods!
add:!adding!public! !
addFolder:!adding!public! !
folderClass!operations!private! !
newNode:!adding!private! !
!

!UI.FolderHierarchyModel class methodsFor!

defaultSearchPolicy
	^SearchPolicy equality!

initialize
	self addClassConstant: 'NodeSortAlgorithm'
		value: (SortedCollection defaultSortAlgorithmClass newSortBlock: [:x :y | x object <= y object])! !
!UI.FolderHierarchyModel class categoriesForMethods!
defaultSearchPolicy!constants!public! !
initialize!development!initializing!private! !
!

