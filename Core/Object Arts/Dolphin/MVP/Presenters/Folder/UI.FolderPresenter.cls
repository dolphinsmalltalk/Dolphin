"Filed out from Dolphin Smalltalk"!

UI.ListPresenter
	subclass: #'UI.FolderPresenter'
	instanceVariableNames: 'treeItem contentsModel isAutoNavigate openBlock history'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.FolderPresenter guid: (Core.GUID fromString: '{87b4c6c7-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.FolderPresenter comment: 'FolderPresenter is a <treePresenter> component that can be used to display the contents of a <treeModel> within a <listView>. The list is used to display the contents of individual parent nodes within the tree. This is similar to the way a folder view (hence the name) is used to display a directory''s contents in the Windows Shell. For presentation of a tree but viewing it as a complete hierarchy see the TreePresenter class.

A FolderPresenter can navigate the tree hierarchy using the #expand:, #collapse: and #up <treePresenter> methods. 

Instance Variables:
	treeItem			<Object> the tree node whose child objects are currently displayed.
	contentsModel		<listModel> holding the current contents.
	isAutoNavigate		<boolean> true if presenter will implicitly navigate the tree.
	openBlock		<dyadicValuable> specifying how an object should be opened.

'!

!UI.FolderPresenter categoriesForClass!MVP-Presenters! !

!UI.FolderPresenter methodsFor!

beNotSorted
	"Change the receiver's view model to be unsorted. We override this
	here to ensure that the receiver's display returns to the true order
	held by the tree model at this level."

	self sortBlock: nil.
	self list: (self model childrenOf: treeItem)!

collapse: anObject
	"Collapse the displayed hierarchy below anObject. If the receiver is currently displaying
	a tree node below anObject's parent then collapse to be displaying the contents of the 
	parent only. Note that it is not legal to collapse nil."

	| parentChain |
	parentChain := self model allParentsOf: treeItem.
	(parentChain includes: anObject) ifTrue: [
		self expand: (self model parentOf: anObject)]!

contents
	"Answers a ListModel that contains the receiver's current displayed contents"

	^contentsModel!

expand: anObjectOrNil
	"Private - Set the receiver to be displaying the contents of anObjectOrNil in the
	receiver's tree. If nil then the roots of the tree are displayed"
	
	| contents |
	treeItem := anObjectOrNil.
	history visit: treeItem.
	contents := treeItem isNil
		ifTrue: [self model roots]
		ifFalse: [self model childrenOf: treeItem].
	self list: contents
	!

expandAll: anObject 
	"Expand the complete hierarchy below anObject (i.e. expand the node and, recursively, 
	all its sub-nodes).
	Implementation Note: We only show a single 'level' at a time, so we just implement this
	to be the same as #expand:"

	self expand: anObject!

hasDrilledDown
	^treeItem notNil!

hasFutureHistory
	^history hasFuture!

hasPastHistory
	^history hasPast!

historyBack
	<commandQuery: #hasPastHistory>
	self expand: (history goBack: 1)!

historyForward
	"Navigate forward one position in the history list."

	<commandQuery: #hasFutureHistory>
	self expand: (history goForward: 1)
!

initialize
	"Private - Initialize the receiver"

	super initialize.
	history := HistoryList new: 10.	"A fairly short history list is appropriate"
	contentsModel := ListModel new.
	self
		isAutoNavigate: true;
		openBlock: [:presenter :object | presenter expand: object]!

isAutoNavigate
	"Answer true if the receiver is in automatic navigation mode; i.e. it will
	automatically attempt to move around the tree hierarchy using standard
	keyboard and mouse gestures"

	^isAutoNavigate!

isAutoNavigate: aBoolean
	"Set the receiver into automatic navigation mode according to aBoolean"

	isAutoNavigate := aBoolean!

list 
	"Private - Answer the contents of the receiver"

	^self viewModel list!

list: aSequenceableCollection
	"Private - Set the contents of the receiver to be aSequenceableCollection"

	| list |
	list := self isSorted 
				ifTrue: [aSequenceableCollection asSortedCollection: self sortBlock]
				ifFalse: [aSequenceableCollection].
	^self viewModel list: list!

model: aTreeModel
	"Connects the receiver to aTreeModel"

	super model: aTreeModel.
	self model
		when: #treeChanged: send: #onTreeChanged: to: self;
		when: #item:addedInParent: send: #onItem:addedInParent: to: self;
		when: #item:removedFromParent: send: #onItem:removedFromParent: to: self;
		when: #item:movedToParent: send: #onItem:movedToParent: to: self;
		when: #itemUpdated: send: #onItemUpdated: to: self.
	self onTreeChanged: nil!

onActionPerformed
	"Handler for an action in the receiver's view.
	An auto-navigate instance evaluates the open block, unless there is none
	in which case the default is to send #openIn: to the item with the receiver	
	as its argument."

	self isAutoNavigate ifTrue: [
		self openBlock value: self value: (self selectionIfNone: [^self]).
		self invalidateUserInterface]!

onItem: anObject addedInParent: aParentObject
	"Private - Event received when anObject has been added to the receiver's
	model within aParentObject. We only need to add the object to the receiver's
	contents if we are currently displaying the parent."

	treeItem == aParentObject ifTrue: [
		self contents add: anObject ]


	!

onItem: anObject movedToParent: aParentObject
	"Private - Event received when anObject has been moved to the receiver's
	model within aParentObject. We only need to add the object to the receiver's
	contents if we are currently displaying the parent."

	(self contents identityIncludes: anObject) ifFalse: [
		treeItem == aParentObject ifTrue: [
			self contents add: anObject ]]


	!

onItem: anObject removedFromParent: aParentObject
	"Private - Event received when anObject has been removed from the receiver's
	model within aParentObject. We only need to remove the object from the receiver's
	contents if we are currently displaying the parent."

	treeItem == aParentObject ifTrue: [
		self contents remove: anObject ]!

onItemUpdated: anObject
	"Private - Event received when anObject has been updated. Refresh the displayed
	contents if they currently contain anObject"

	self contents refresh: anObject!

onKeyTyped: aKeyEvent
	"Default handler for the receiver's view receiving a key entry."

	self isAutoNavigate ifTrue: [
		aKeyEvent code==VK_BACK ifTrue: [ ^self up ]].
	^self view onKeyTyped: aKeyEvent!

onTreeChanged: anObject
	"Private - Event received when the tree has been changed at anObject"

	self expand: anObject!

openBlock
	"Answers the <dyadicValuable> open block for the receiver"

	^openBlock!

openBlock: aDyadicValuable
	"Sets the <dyadicValuable> open block for the receiver to aDyadicValuable. This is
	evaluated to determine what action to take when an attempt is made to open one of
	the objects in the receiver. The first parameter is the folder presenter itself and the
	second is the object being opened."

	openBlock := aDyadicValuable!

up
	"Display the contents of the immediate parent of the current tree item"

	<commandQuery: #hasDrilledDown>
	treeItem notNil 
		ifTrue: 
			[| parent |
			parent := self model parentOf: treeItem.
			history visit: parent.
			parent == treeItem ifFalse: [self expand: parent]]!

viewModel
	"Private - Answer the model that is to be connected to the view. It is actually
	connected to the receiver's contentsModel - not the receiver's tree model"

	^self contents! !

!UI.FolderPresenter categoriesForMethods!
beNotSorted!accessing!public!sorting! !
collapse:!operations!public! !
contents!accessing!public! !
expand:!operations!public! !
expandAll:!operations!public! !
hasDrilledDown!public!testing! !
hasFutureHistory!public!testing! !
hasPastHistory!public!testing! !
historyBack!commands-actions!public! !
historyForward!commands-actions!public! !
initialize!initializing!private! !
isAutoNavigate!accessing!public! !
isAutoNavigate:!accessing!public! !
list!accessing!private! !
list:!accessing!private! !
model:!accessing!public! !
onActionPerformed!event handling!public! !
onItem:addedInParent:!event handling!private! !
onItem:movedToParent:!event handling!private! !
onItem:removedFromParent:!event handling!private! !
onItemUpdated:!event handling!private! !
onKeyTyped:!event handling!public! !
onTreeChanged:!event handling!private! !
openBlock!accessing!public! !
openBlock:!accessing!public! !
up!commands-actions!public! !
viewModel!accessing!private! !
!

UI.FolderPresenter methodProtocol: #treePresenter attributes: #(#readOnly) selectors: #(#collapse: #ensureVisible #expand: #expandAll: #onAboutToDisplayMenu: #onActionPerformed #onCloseRequested #onIdleEntered #onInputMaskRequired: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onKillFocus #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMouseMoved: #onPositionChanged: #onPositionChanging: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSetFocus #onTipTextRequired: #onViewClosed #onViewOpened #parentPresenter #performAction #setFocus #show #topShell #up #view)!

!UI.FolderPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^TreeModel new!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) instanceClass defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ListView} 38 #{Core.Array} 45 nil nil 50 2 8 1409372236 1025 32 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 32 nil nil 518 #{Core.Message} #displayString 8 #() 242 #iconImageIndex 272 1350 1 #{Graphics.IconImageManager} nil nil nil 518 #{Graphics.Point} 65 65 nil nil 146 1 3142 5 #{UI.ListViewColumn} 8 'Column 1' 201 #left 256 242 #<= 8 #() nil nil 32 nil 1 nil nil #largeIcons 8 #() nil 131169 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 338 6143 21 338 491 311 32 530 #text: 50 1 8 'Column 1' 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 244 12 0 0 165 0 0 0] 8 #() 338 193 193 nil 35)! !

!UI.FolderPresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

