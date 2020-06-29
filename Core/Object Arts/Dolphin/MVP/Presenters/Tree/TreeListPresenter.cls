"Filed out from Dolphin Smalltalk 7"!

TreePresenter subclass: #TreeListPresenter
	instanceVariableNames: 'listModel updating visibleNodes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
TreeListPresenter guid: (GUID fromString: '{2e6f856c-a8b4-4d90-8e8f-adf2452e4bbf}')!
TreeListPresenter comment: 'TreeListPresenter implements a <listPresenter> component that can be used to display the contents of a <listModel> within a <treeView>.  It also conforms to <selectableItems> and <indexSelectableItems> to provide methods for accessing the current selection(s) in the list. The hierarchical presentation is controlled by a tree model (set separately using #treeModel:) but the actual visible nodes are determined by the contents of the list. Only those nodes that are actually in the list or are parents of those in the list will be displayed.

Note the <treeModel> must be a VirtualTreeModel, and it is assumed that the list represents a view onto the full set (i.e. a subset) of items in the tree. Furthermore it is assumed that when a new item is added to the list, it is already in the underlying tree, therefore items added to the list are not automatically added into the tree model.

In the default view, the intermediate nodes (i.e. those not in the list) are displayed in a faded colour. By default, these nodes are selectable but this decision can be controlled using #hasProtectedIntermediateNodes:.

Instance Variables:
	treePresenter		<treePresenter> used to display the objects in the receiver''s list in a hierarchical format.
	updating			<Boolean>. Set when performing model updates to prevent infinite loop.

Class Variables:



'!
!TreeListPresenter categoriesForClass!MVP-Presenters! !
!TreeListPresenter methodsFor!

addNewNode: anObject 
	"Private - The <Object> argument has been added to the receiver's model (the list). Update
	the tree to include it, potentially adding new infrastructural nodes if objects in its
	parent chain are not in the list."

	| chain node tree |
	chain := OrderedCollection with: anObject.
	tree := self treeModel.
	node := tree parentOf: anObject.
	[node isNil or: [visibleNodes includes: node]] whileFalse: 
			[chain addLast: node.
			node := tree parentOf: node].
	visibleNodes addAll: chain.
	chain reverseDo: 
			[:each | 
			"We can't use #add:asChildOf: to cause the node to be added to the view,
			because virtual trees treat root nodes as a special case and do maintain a
			collection of them. This means we might end up adding a duplicate root."
			tree notifyAdded: each toParent: node.
			node := each]!

addNode: anObject 
	^(visibleNodes includes: anObject) 
		ifTrue: 
			["Item already in tree - but we should refresh it in case it has changed
			 status from infrastructural to full item"
			self treeModel refresh: anObject]
		ifFalse: [self addNewNode: anObject]!

connectModel
	(self model)
		when: #listChanged
			send: #onListChanged
			to: self;
		when: #item:updatedAtIndex:
			send: #onListItem:updatedAtIndex:
			to: self;
		when: #item:addedAtIndex:
			send: #onListItem:addedAtIndex:
			to: self;
		when: #item:removedAtIndex:
			send: #onListItem:removedAtIndex:
			to: self!

connectTreeModel
	(self treeModel)
		when: #itemUpdated:
			send: #onTreeItemUpdated:
			to: self;
		when: #treeChanged:
			send: #onTreeChanged:
			to: self;
		when: #item:addedInParent:
			send: #onTreeItem:addedInParent:
			to: self;
		when: #removingItem:
			send: #onTreeRemovingItem:
			to: self;
		when: #item:movedToParent:
			send: #onTreeItem:movedToParent:
			to: self!

doModelUpdate: aNiladicBlock 
	self assert: [updating not].
	updating := true.
	aNiladicBlock ensure: [updating := false]!

initialize
	"Private - Initialize the receiver"

	updating := false.
	super initialize!

isInTree: anObject 
	^self treeModel includes: anObject!

list 
	"Answer the contents of the receiver"

	^self model list!

list: aSequenceableCollection
	"Set the contents of the receiver to be aSequenceableCollection"

	^self model list: aSequenceableCollection!

model
	"Private - Answer the list model used to display the contents of the receiver"

	^listModel!

model: aListModel 
	"Set the list model used to display the contents of the receiver"

	listModel := aListModel.
	self connectModel.
	self treeModel isNil ifTrue: [self treeModel: VirtualTreeModel new]!

onListChanged
	"Private - The receiver's list has changed. Repopulate the tree"

	self noEventsDo: [self updateTree]

!

onListItem: anObject addedAtIndex: anInteger 
	"An item has been added to the list. This may mean that it, and any ancestors, need to be
	added to the tree filter. Alternatively it may already be present in the tree for
	infrastructural purposes (i.e. it is a node on the path to an item that was previously in
	the list). In this case it needs to be refreshed to reflect its new status as a fully
	fledged item - this will presumably have some visual effect, but that does depend on the
	view configuration."

	updating ifTrue: [^self].
	self doModelUpdate: [self addNode: anObject]!

onListItem: anObject removedAtIndex: anInteger 
	"The specified <Object> has been removed from the receiver's list model. It is an invariant
	that any item in the list must also be in the tree, so we must rebuild the tree (unless the
	event is a circular one resulting from us updating the list to reflect a change in the
	tree). Note that the object may still be required in the tree for infrastructural purposes,
	even if it is no longer in the list, so the item may not actually be removed from the tree."

	updating ifTrue: [^self].
	self assert: [self isInTree: anObject].
	self doModelUpdate: [self removeNode: anObject]!

onListItem: anObject updatedAtIndex: anInteger 
	"The specified <Object> has been updated in the receiver's list model. It is an invariant
	that any item in the list, must be in the tree (the content of the list is a proper subset
	of that of the tree), so we must update the object in the tree too. The exception to this is
	where this update notification has arisen as a result of us updating the list to match a
	change in the tree (i.e. it is circular), in which case the updating flag will be set."

	updating ifTrue: [^self].
	self assert: [self isInTree: anObject].
	self doModelUpdate: [self treeModel refresh: anObject]!

onTreeChanged: anObject 
	"Private - The hiearchy of the tree model has been updated below the specified node (nil if the root)."

	updating ifTrue: [^self].
	self doModelUpdate: 
			[| tree |
			tree := self treeModel.
			self model removeAll: (self model reject: [:each | tree includes: each]).
			self rebuildFilter]!

onTreeItem: anObject addedInParent: parentObject 
	"The specified <Object> has been added to the receiver's tree model. Note that for this to
	event to be received, the new Object must have passed the filter, and therefore it should
	also be in the list. In other words it is an invariant that items added to the tree which
	pass its filter must already be in the list."

	updating ifTrue: [^self].
	self assert: [self model includes: anObject]!

onTreeItem: anObject movedToParent: parentObject 
	"Private - An item in the tree's model (which must have passed the filter, or we would not
	be getting this event) has been reparented. There are a number of cases to consider:

	1) It has been moved under a parent that is not currently in the tree, and if so we must
	rebuild the tree to add new infrastructural nodes.

	2) The parent it has been moved from was present for infrastructural purposes only and is no
	longer needed, so it should be removed from the tree.

	3) There is no effect on the tree's content as both old and new parents should be present
	before and after the move.

	Unfortunately the event does not tell us of the previous parent, so we have to treat all
	cases in the same way and refresh the tree."


	updating ifTrue: [^self].
	(false and: [self treeModel filter value: parentObject])
		ifFalse: 
			[self doModelUpdate: 
					["The necessary infrastructural nodes are not in the tree
					 following the reparenting, so we must update the filter and the tree."
					self refresh]]!

onTreeItemUpdated: anObject 
	"The specified <Object> has been updated in the receiver's tree model. If included in the
	list, and the event is not a circular one resulting from us updating the tree to reflect a
	change in the list, refresh the object in the list to update the list's observers."

	updating ifTrue: [^self].
	self doModelUpdate: [self model refresh: anObject ifAbsent: []]!

onTreeRemovingItem: anObject 
	"The specified <Object> is being removed from the underlying tree model, so we have to
	remove it from the list too."

	updating ifTrue: [^self].
	self doModelUpdate: 
			[| tree |
			tree := self treeModel.
			(tree withAllChildren: anObject) do: 
					[:each | 
					self model remove: each ifAbsent: [].
					visibleNodes remove: each ifAbsent: []]]!

rebuildFilter
	| aVirtualTreeModel |
	aVirtualTreeModel := self treeModel.
	visibleNodes := Set new.
	self list do: 
			[:each |
			"Avoid the cost of walking the parent chain if object is already in the set."
			(visibleNodes addNewElement: each)
				ifTrue: [visibleNodes addAll: (aVirtualTreeModel allParentsOf: each)]]!

refresh
	"Private - Refresh the display of the receiver"

	| originalSelection |
	originalSelection := self selectionOrNil.
	self noEventsDo: 
			[self updateTree.
			self selection: originalSelection ifAbsent: []]!

removeNode: anObject 
	| tree |
	tree := self treeModel.
	(tree hasChildren: anObject) 
		ifTrue: [tree refresh: anObject]
		ifFalse: 
			["May need to chain up to remove/refresh infrastructural nodes"
			| parent |
			parent := tree notifyRemove: anObject around: [visibleNodes remove: anObject].
			(parent isNil or: [self list includes: parent]) ifFalse: [self removeNode: parent]]!

treeModel
	"Private - Answer the tree model used to display the contents of the receiver"

	^super model!

treeModel: aVirtualTreeModel 
	"Set the tree model used to display the contents of the receiver to the <VirtualTreeModel> argument."

	super model: aVirtualTreeModel.
	self connectTreeModel.
	aVirtualTreeModel filter: [:each | visibleNodes includes: each].
	self rebuildFilter!

updateTree
	self rebuildFilter.
	^self view refreshContents!

viewModel
	"Private - Answer the model that is to be connected to the view. It is actually
	connected to the receiver's tree model - not the receiver's list model"

	^self treeModel! !
!TreeListPresenter categoriesFor: #addNewNode:!helpers!private! !
!TreeListPresenter categoriesFor: #addNode:!helpers!private! !
!TreeListPresenter categoriesFor: #connectModel!initializing!private! !
!TreeListPresenter categoriesFor: #connectTreeModel!initializing!private! !
!TreeListPresenter categoriesFor: #doModelUpdate:!helpers!private!updating! !
!TreeListPresenter categoriesFor: #initialize!initializing!private! !
!TreeListPresenter categoriesFor: #isInTree:!helpers!private! !
!TreeListPresenter categoriesFor: #list!accessing!public! !
!TreeListPresenter categoriesFor: #list:!accessing!public! !
!TreeListPresenter categoriesFor: #model!accessing!private! !
!TreeListPresenter categoriesFor: #model:!accessing!public! !
!TreeListPresenter categoriesFor: #onListChanged!event handling!private! !
!TreeListPresenter categoriesFor: #onListItem:addedAtIndex:!event handling!private! !
!TreeListPresenter categoriesFor: #onListItem:removedAtIndex:!event handling!private! !
!TreeListPresenter categoriesFor: #onListItem:updatedAtIndex:!event handling!private! !
!TreeListPresenter categoriesFor: #onTreeChanged:!event handling!private! !
!TreeListPresenter categoriesFor: #onTreeItem:addedInParent:!event handling!private! !
!TreeListPresenter categoriesFor: #onTreeItem:movedToParent:!event handling!private! !
!TreeListPresenter categoriesFor: #onTreeItemUpdated:!event handling!private! !
!TreeListPresenter categoriesFor: #onTreeRemovingItem:!event handling!private! !
!TreeListPresenter categoriesFor: #rebuildFilter!private!updating! !
!TreeListPresenter categoriesFor: #refresh!private!updating! !
!TreeListPresenter categoriesFor: #removeNode:!helpers!private! !
!TreeListPresenter categoriesFor: #treeModel!accessing!private! !
!TreeListPresenter categoriesFor: #treeModel:!accessing!public! !
!TreeListPresenter categoriesFor: #updateTree!private!updating! !
!TreeListPresenter categoriesFor: #viewModel!accessing!private! !

!TreeListPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^ListModel new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.TreeView) 34 27 nil nil 34 2 8 1409352231 1025 416 590918 3 ##(Smalltalk.TreeModel) nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 8 #() 327686 ##(Smalltalk.Color) #default nil 13 nil nil nil 416 nil 8 1903706176 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 9 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | 
(ctx view presenter list includes: ctx item) 
	ifFalse: [ctx forecolor: ctx forecolor faded]]' 8 #[37 105 17 158 159 160 17 161 180 220 6 233 0 163 164 183 106 60 106] #view #presenter #list #item #includes: #forecolor #faded #forecolor: 752 7 257 nil nil nil 170 176 592 33 #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 592 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 994 701 501 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 8 #() 994 193 193 nil 27 )! !
!TreeListPresenter class categoriesFor: #defaultModel!models!public! !
!TreeListPresenter class categoriesFor: #resource_Default_view!public!resources-views! !

