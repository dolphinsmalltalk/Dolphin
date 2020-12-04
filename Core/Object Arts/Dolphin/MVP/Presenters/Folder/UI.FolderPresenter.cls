"Filed out from Dolphin Smalltalk 7"!

UI.ListPresenter subclass: #'UI.FolderPresenter'
	instanceVariableNames: 'treeItem contentsModel isAutoNavigate openBlock history'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.FolderPresenter guid: (Core.GUID fromString: '{87b4c6c7-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.FolderPresenter comment: 'FolderPresenter is a <treePresenter> component that can be used to display the contents of a <treeModel> within a <listView>. The list is used to display the contents of individual parent nodes within the tree. This is similar to the way a folder view (hence the name) is used to display a directory''s contents in the Windows Shell.. For presentation of a tree but viewing it as a complete hierarchy see the TreePresenter class.

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
	"Collapse the displayed hierarchy below anObject.If the receiver is currently displaying
	a tree node below anObject's parent then collapse to be displaying the contents of the 
	parent only. Note that is is not legal to collapse nil."

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

historyBack
	self expand: (history goBack: 1)!

historyForward
	"Navigate forward one position in the history list."

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

queryCommand: query
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery>, query."

	| cmd |
	cmd := query commandSymbol.

	cmd == #up ifTrue: [
		query isEnabled: treeItem notNil.
		^true].

	cmd == #historyBack ifTrue: [
		query isEnabled: history hasPast.
		^true].

	cmd == #historyForward ifTrue: [
		query isEnabled: history hasFuture.
		^true].

	^super queryCommand: query!

up
	"Display the contents of the immediate parent of the current tree item"

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
!UI.FolderPresenter categoriesFor: #beNotSorted!accessing!public!sorting! !
!UI.FolderPresenter categoriesFor: #collapse:!operations!public! !
!UI.FolderPresenter categoriesFor: #contents!accessing!public! !
!UI.FolderPresenter categoriesFor: #expand:!operations!public! !
!UI.FolderPresenter categoriesFor: #expandAll:!operations!public! !
!UI.FolderPresenter categoriesFor: #historyBack!commands!public! !
!UI.FolderPresenter categoriesFor: #historyForward!commands!public! !
!UI.FolderPresenter categoriesFor: #initialize!initializing!private! !
!UI.FolderPresenter categoriesFor: #isAutoNavigate!accessing!public! !
!UI.FolderPresenter categoriesFor: #isAutoNavigate:!accessing!public! !
!UI.FolderPresenter categoriesFor: #list!accessing!private! !
!UI.FolderPresenter categoriesFor: #list:!accessing!private! !
!UI.FolderPresenter categoriesFor: #model:!accessing!public! !
!UI.FolderPresenter categoriesFor: #onActionPerformed!event handling!public! !
!UI.FolderPresenter categoriesFor: #onItem:addedInParent:!event handling!private! !
!UI.FolderPresenter categoriesFor: #onItem:movedToParent:!event handling!private! !
!UI.FolderPresenter categoriesFor: #onItem:removedFromParent:!event handling!private! !
!UI.FolderPresenter categoriesFor: #onItemUpdated:!event handling!private! !
!UI.FolderPresenter categoriesFor: #onKeyTyped:!event handling!public! !
!UI.FolderPresenter categoriesFor: #onTreeChanged:!event handling!private! !
!UI.FolderPresenter categoriesFor: #openBlock!accessing!public! !
!UI.FolderPresenter categoriesFor: #openBlock:!accessing!public! !
!UI.FolderPresenter categoriesFor: #queryCommand:!commands!private! !
!UI.FolderPresenter categoriesFor: #up!commands!public! !
!UI.FolderPresenter categoriesFor: #viewModel!accessing!private! !

UI.FolderPresenter methodProtocol: #treePresenter attributes: #(#readOnly) selectors: #(#collapse: #ensureVisible #expand: #expandAll: #onAboutToDisplayMenu: #onActionPerformed #onCloseRequested #onIdleEntered #onInputMaskRequired: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onKillFocus #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMouseMoved: #onPositionChanged: #onPositionChanging: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSetFocus #onTipTextRequired: #onViewClosed #onViewOpened #parentPresenter #performAction #setFocus #show #topShell #up #view)!

!UI.FolderPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^TreeModel new!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) instanceClass defaultIcon! !
!UI.FolderPresenter class categoriesFor: #defaultModel!models!public! !
!UI.FolderPresenter class categoriesFor: #icon!constants!public! !

