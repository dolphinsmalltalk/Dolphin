"Filed out from Dolphin Smalltalk"!

UI.ListPresenter
	subclass: #'UI.ListTreePresenter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ListTreePresenter guid: (Core.GUID fromString: '{b4f22156-df92-493f-81c9-6e74fd4fdcce}')!
UI.ListTreePresenter comment: 'Copyright © Chris Uppal, 2002, 2003.
chris.uppal@metagnostic.org

These presenters are intended to pair with ListTreeViews, however in almost all cases they are not needed since it suffices to clip a ListPresenter or TreePresenter to the TreeView.  One case where that wouldn''t work is where you need a TreePresenter that understands that the selection may be multiple (which TreePresenter doesn''t) *and* knows about trees (which ListPresenter doesn''t).

Here''s an example:

	ListTreeView example2c	"do it"

See the class comment of ListTreeView for more information.

	-- chris'!
!UI.ListTreePresenter categoriesForClass!MVP-Presenters! !
!UI.ListTreePresenter methodsFor!

beNotSorted
	"remove any sorting of the model. This is almost a null-op since we
	don't acually use a sorted collection"

	self sortBlock: nil.!

beSorted
	"change the receiver's model to be a SortedCollection 
	using a default sort block"

	self beSorted: self defaultSortBlock.!

beSorted: aSortBlock
	"change the order in which the roots of the model are displayed to that implied by aSortBlock,
	and recursively to each list of children under any parent.  Note that this doesn't (unlike the
	superclass implementation) change the class of the model -- in fact it doesn't change the
	model at all..."

	self sortBlock: aSortBlock.
	self view sortBlock: aSortBlock.
!

collapse: anObject
	"ensure that all immediate children of anObject are not displayed in our view"

	self view collapse: anObject.!

expand: anObject
	"ensure that all immediate children of anObject are displayed in our view"

	self view expand: anObject.!

expandAll: anObject
	"ensure that all (recursive) children of anObject are displayed in our view.
	If anObject is nil then it expands all the roots"

	self view expandAll: anObject.!

isMultiSelect
	"Answer whether our view supports multiple selections."

	^self view isMultiSelect!

list
	"answer the contents of the receiver.
	Overriden since our own 'model' is not the one used
	by our view, and the list should be regarded as readonly"

	"we can probably do better than this, but it'll do for now"
	self view model list shallowCopy.
!

list: aSequenceableCollection
	"set the contents of the receiver.
	Overriden since our own 'model' is not the one used
	by our view"

	"we can probably do better than this, but it'll do for now"
	self shouldNotImplement.!

model: anObject
	"set the model of the receiver to be anObject. Overriden to
	pick up the View's sortBlock if any"

	super model: anObject.
	self sortBlock: self view sortBlock.!

treeModel
	"answer the real tree model used by our view"

	^ self view treeModel.!

up
	"ask our view to move the selection up one generation.
	Note that this can have rather odd effects if the view is
	multiselection"

	| sels |

	sels := self view selectionsAsSet.
	sels := sels collect: [:each | self view parentOf: each].
	self view selections: sels asOrderedCollection.! !
!UI.ListTreePresenter categoriesForMethods!
beNotSorted!accessing!public!sorting! !
beSorted!accessing!public!sorting! !
beSorted:!accessing!public!sorting! !
collapse:!operations!public! !
expand:!operations!public! !
expandAll:!operations!public! !
isMultiSelect!public!testing! !
list!accessing!public! !
list:!accessing!public! !
model:!accessing!public! !
treeModel!accessing!operations!public! !
up!operations!public! !
!

UI.ListTreePresenter methodProtocol: #treePresenter attributes: #(#readOnly) selectors: #(#collapse: #ensureVisible #expand: #expandAll: #onAboutToDisplayMenu: #onActionPerformed #onCloseRequested #onIdleEntered #onInputMaskRequired: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onKillFocus #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMouseMoved: #onPositionChanged: #onPositionChanging: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSetFocus #onTipTextRequired: #onViewClosed #onViewOpened #parentPresenter #performAction #setFocus #show #topShell #up #view)!

!UI.ListTreePresenter class methodsFor!

defaultModel
	"answer a default model to be assigned to the receiver when it
	is initialized."

	^TreeModel new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ListTreeView} 34 59 nil nil 34 2 8 1140920397 1025 416 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} 917510 #{Graphics.Color} #default nil 7 nil nil nil 416 nil 8 1815049392 786950 #{Core.Message} #displayString 528 626 #iconImageIndex 528 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 'Column 1' 391 #left 640 626 #<= 8 #() nil nil 416 nil 3 nil nil #report 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil true 1247046 3 #{UI.VirtualTreeModel} nil 560 138 144 528 1246566 3 #{Kernel.BlockClosure} 0 nil 1377574 #{Kernel.CompiledMethod} 2 3 832 #defaultGetChildrenBlock 42440101 8 #[30 105 226 0 106] #children 896 7 257 nil 882 0 nil 914 2 3 832 #defaultGetParentBlock 42415045 8 #[30 105 226 0 106] #parent 960 7 257 nil 882 0 nil 914 2 3 832 #defaultHasChildrenBlock 42500293 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 848 882 0 nil 914 1 83886083 832 #defaultFilterBlock 42430373 8 #[29 105 17 157 106] 1056 7 257 nil nil 138 #{Core.PluggableSet} 528 138 #{Core.IdentitySet} 528 37 1 nil nil nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 1234 399 701 416 1186 #text: 34 1 8 'Column 1' 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 198 24 0 0 104 1 0 0] 8 #() 1234 193 193 nil 2029)! !
!UI.ListTreePresenter class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

