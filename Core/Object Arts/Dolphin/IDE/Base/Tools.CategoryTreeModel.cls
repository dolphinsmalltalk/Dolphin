"Filed out from Dolphin Smalltalk 7"!

TreeModel subclass: #CategoryTreeModel
	instanceVariableNames: 'title'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CategoryTreeModel guid: (GUID fromString: '{87b4c671-026e-11d3-9fd7-00a0cc3e4a32}')!
CategoryTreeModel comment: 'CategoryTreeModel represents a <treeModel> holding <Category> objects.

Instance Variables:
	title	<IntermediateCategory> the root of the tree.

'!
!CategoryTreeModel categoriesForClass!MVP-Models! !
!CategoryTreeModel methodsFor!

addCategory: aCategory
	"Private - Adds aCategory and all of its parent categories to the receiver. 
	Parses the name of aCategory to split off the parents"

	| name sep parent |
	name := aCategory name.
	sep := aCategory class separator.
	parent := title.

	"Do fast check to avoid expense of subStrings: for common case"
	(name identityIncludes: sep)
		ifTrue: 
			[| names moniker |
			names := sep split: name.
			moniker := String writeStream.
			names
				from: 1
				to: names size - 1
				do: 
					[:part |
					| branch |
					moniker nextPutAll: part.
					branch := self add: (IntermediateCategory name: moniker contents) asChildOf: parent.
					moniker nextPut: sep.
					parent := branch]].
	self add: aCategory asChildOf: parent!

list: list
	"Set the contents of the receiver to be the <Collection>, of <Category>s in list"

	self clear.

	"Add a title node if there is one"
	title notNil ifTrue: [self addRoot: title].
	(list asSortedCollection: [:a :b | a name < b name]) 
		do: [:each | self addCategory: each]!

title
	"Answer the top most node in the tree."

	^title!

title: category
	"Set the topmost node of the tree to be the specified <Category>"

	title := category! !
!CategoryTreeModel categoriesFor: #addCategory:!adding!private! !
!CategoryTreeModel categoriesFor: #list:!accessing!public! !
!CategoryTreeModel categoriesFor: #title!accessing!public! !
!CategoryTreeModel categoriesFor: #title:!accessing!public! !

!CategoryTreeModel class methodsFor!

defaultSearchPolicy
	^SearchPolicy equality! !
!CategoryTreeModel class categoriesFor: #defaultSearchPolicy!constants!public! !

