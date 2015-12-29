"Filed out from Dolphin Smalltalk X6.2"!

ListPresenter subclass: #ListTreePresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ListTreePresenter guid: (GUID fromString: '{B4F22156-DF92-493F-81C9-6E74FD4FDCCE}')!
ListTreePresenter comment: 'Copyright © Chris Uppal, 2002, 2003.
chris.uppal@metagnostic.org

These presenters are intended to pair with ListTreeViews, however in almost all cases they are not needed since it suffices to clip a ListPresenter or TreePresenter to the TreeView.  One case where that wouldn''t work is where you need a TreePresenter that understands that the selection may be multiple (which TreePresenter doesn''t) *and* knows about trees (which ListPresenter) doesn''t.

Here''s an example:

	ListTreeView example2c	"do it"

See the class comment of ListTreeView for more information.

	-- chris'!
!ListTreePresenter categoriesForClass!MVP-Presenters! !
!ListTreePresenter methodsFor!

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
!ListTreePresenter categoriesFor: #beNotSorted!accessing!public!sorting! !
!ListTreePresenter categoriesFor: #beSorted!accessing!public!sorting! !
!ListTreePresenter categoriesFor: #beSorted:!accessing!public!sorting! !
!ListTreePresenter categoriesFor: #collapse:!operations!public! !
!ListTreePresenter categoriesFor: #expand:!operations!public! !
!ListTreePresenter categoriesFor: #expandAll:!operations!public! !
!ListTreePresenter categoriesFor: #isMultiSelect!public!testing! !
!ListTreePresenter categoriesFor: #list!accessing!public! !
!ListTreePresenter categoriesFor: #list:!accessing!public! !
!ListTreePresenter categoriesFor: #model:!accessing!public! !
!ListTreePresenter categoriesFor: #treeModel!accessing!operations!public! !
!ListTreePresenter categoriesFor: #up!operations!public! !

ListTreePresenter methodProtocol: #treePresenter attributes: #(#readOnly) selectors: #(#collapse: #ensureVisible #expand: #expandAll: #onAboutToDisplayMenu: #onActionPerformed #onCloseRequested #onIdleEntered #onInputMaskRequired: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onKillFocus #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMouseMoved: #onPositionChanged: #onPositionChanging: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSetFocus #onTipTextRequired: #onViewClosed #onViewOpened #parentPresenter #performAction #setFocus #show #topShell #up #view)!

!ListTreePresenter class methodsFor!

defaultModel
	"answer a default model to be assigned to the receiver when it
	is initialized."

	^ TreeModel new.!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ListTreeView)  98 44 0 0 98 2 8 1140920397 1025 416 590662 2 ##(ListModel)  202 208 98 0 0 1114638 ##(STBSingletonProxy)  8 ##(SearchPolicy)  8 #identity 524550 ##(ColorRef)  8 4278190080 0 7 0 0 0 416 0 8 4294902987 8 ##(BasicListAbstract)  8 ##(IconicListAbstract)  570 8 ##(IconImageManager)  8 #current 0 0 0 0 0 0 202 208 98 1 920646 5 ##(ListViewColumn)  8 'Column 1' 391 8 #left 688 8 ##(SortedCollection)  0 0 416 0 3 0 0 8 #report 544 0 133217 0 0 16 1050438 3 ##(VirtualTreeModel)  0 576 202 208 544 787814 3 ##(BlockClosure)  0 0 918822 ##(CompiledMethod)  2 3 896 8 #defaultGetChildrenBlock 42440101 8 #[30 105 226 0 106] 8 #children 960 7 257 0 946 0 0 978 2 3 896 8 #defaultGetParentBlock 42415045 8 #[30 105 226 0 106] 8 #parent 1056 7 257 0 946 0 0 978 2 3 896 8 #defaultHasChildrenBlock 42500293 8 #[252 1 0 0 1 4 0 65 176 159 106 105] 8 #childrenOf: 8 #notEmpty 17 257 912 946 0 0 978 1 83886083 896 8 #defaultFilterBlock 42430373 8 #[29 105 17 157 106] 1232 7 257 0 0 202 8 ##(PluggableSet)  544 202 1312 544 37 1 0 0 0 0 0 0 0 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  11 11 1474 399 701 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 204 0 0 0 99 1 0 0] 98 0 1474 193 193 0 2021 )! !
!ListTreePresenter class categoriesFor: #defaultModel!models!public! !
!ListTreePresenter class categoriesFor: #resource_Default_view!public!resources-views! !

