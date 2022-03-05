"Filed out from Dolphin Smalltalk"!

ListPresenter subclass: #ListTreePresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ListTreePresenter guid: (GUID fromString: '{b4f22156-df92-493f-81c9-6e74fd4fdcce}')!
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
!ListTreePresenter categoriesForMethods!
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ListTreeView) 34 59 nil nil 34 2 8 1140920397 1025 416 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil 8 1883852064 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Column 1' 391 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() nil nil 416 nil 3 nil nil #report 528 nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil true 1050438 3 ##(Smalltalk.VirtualTreeModel) nil 560 138 144 528 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 784 #defaultGetChildrenBlock 42440101 8 #[30 105 226 0 106] #children 848 7 257 nil 834 0 nil 866 2 3 784 #defaultGetParentBlock 42415045 8 #[30 105 226 0 106] #parent 912 7 257 nil 834 0 nil 866 2 3 784 #defaultHasChildrenBlock 42500293 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 800 834 0 nil 866 1 83886083 784 #defaultFilterBlock 42430373 8 #[29 105 17 157 106] 1008 7 257 nil nil 138 ##(Smalltalk.PluggableSet) 528 138 ##(Smalltalk.IdentitySet) 528 37 1 nil nil nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 7039 21 1202 399 701 416 1154 #text: 34 1 8 'Column 1' 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 134 14 0 0 104 1 0 0] 8 #() 1202 193 193 nil 2029 )! !
!ListTreePresenter class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

