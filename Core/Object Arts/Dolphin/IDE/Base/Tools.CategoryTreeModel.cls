"Filed out from Dolphin Smalltalk"!

UI.TreeModel
	subclass: #'Tools.CategoryTreeModel'
	instanceVariableNames: 'title'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.CategoryTreeModel guid: (Core.GUID fromString: '{87b4c671-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.CategoryTreeModel comment: 'CategoryTreeModel represents a <treeModel> holding <Category> objects.

Instance Variables:
	title	<IntermediateCategory> the root of the tree.

'!
!Tools.CategoryTreeModel categoriesForClass!MVP-Models! !
!Tools.CategoryTreeModel methodsFor!

addCategory: aCategory
	"Private - Adds aCategory and all of its parent categories to the receiver. 
	Parses the name of aCategory to split off the parents"

	| name parent i end |
	parent := title.
	name := aCategory name.
	end := name size.
	i := 0.
	
	[i := name
				nextIdentityIndexOf: Category.Separator
				from: i + 1
				to: end.
	i == 0]
			whileFalse: 
				[parent := self add: (IntermediateCategory name: (name copyFrom: 1 to: i - 1)) asChildOf: parent].
	self add: aCategory asChildOf: parent!

list: list
	"Set the contents of the receiver to be the <Collection>, of <Category>s in list"

	self clear.

	"Add a title node if there is one"
	title notNil ifTrue: [self addRoot: title].
	(list asSortedArray: [:a :b | a name < b name]) do: [:each | self addCategory: each]!

title
	"Answer the top most node in the tree."

	^title!

title: category
	"Set the topmost node of the tree to be the specified <Category>"

	title := category! !
!Tools.CategoryTreeModel categoriesForMethods!
addCategory:!adding!private! !
list:!accessing!public! !
title!accessing!public! !
title:!accessing!public! !
!

!Tools.CategoryTreeModel class methodsFor!

defaultSearchPolicy
	^SearchPolicy equality! !
!Tools.CategoryTreeModel class categoriesForMethods!
defaultSearchPolicy!constants!public! !
!

