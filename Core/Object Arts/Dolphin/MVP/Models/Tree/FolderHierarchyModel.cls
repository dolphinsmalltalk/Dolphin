"Filed out from Dolphin Smalltalk"!

TreeModel subclass: #FolderHierarchyModel
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FolderHierarchyModel guid: (GUID fromString: '{2dfe6611-349c-497a-969b-cc0aea7ecc70}')!

FolderHierarchyModel comment: 'FolderHierarchyModel is a specialized <TreeModel> that holds a directory hierarchy, with nodes representing each directory/folder in the hierarchy. The nodes are maintained in sorted order.
'!

!FolderHierarchyModel categoriesForClass!MVP-Models! !

!FolderHierarchyModel methodsFor!

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
		children: (SortedCollection sortBlock: [:x :y | x object <= y object]);
		yourself! !

!FolderHierarchyModel categoriesForMethods!
add:!adding!public! !
addFolder:!adding!public! !
folderClass!operations!private! !
newNode:!adding!private! !
!

!FolderHierarchyModel class methodsFor!

defaultSearchPolicy
	^SearchPolicy equality! !

!FolderHierarchyModel class categoriesForMethods!
defaultSearchPolicy!constants!public! !
!

