"Filed out from Dolphin Smalltalk"!

UI.SelectableItemsPresenter
	subclass: #'UI.ListPresenter'
	instanceVariableNames: 'sortBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ListPresenter guid: (Core.GUID fromString: '{87b4c685-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.ListPresenter comment: 'ListPresenter implements a <listPresenter> component that can be used to display the contents of a <listModel> within a <listView>.  It also conforms to <selectableItems> and <indexSelectableItems> to provide methods for accessing the current selection(s) in the list.

Instance Variables:
	sortBlock		<dyadicValuable> or nil, specifying how an object should be sorted.



'!

!UI.ListPresenter categoriesForClass!MVP-Presenters! !

!UI.ListPresenter methodsFor!

basicBeSorted
	"Private - Change the receiver's model sortblock to a default sort block.
	The sort is not actually performed"

	self sortBlock: self defaultSortBlock!

beNotSorted
	"Change the receiver's view model to be an OrderedCollection"

	self sortBlock: nil.
	self list: self list asOrderedCollection!

beSorted
	"Change the receiver's model to be a SortedCollection 
	using a default sort block"

	self basicBeSorted.
	self list: self list asOrderedCollection.!

beSorted: aSortBlock
	"Change the receiver's model to be a SortedCollection using aSortBlock to determine sort order"

	self sortBlock: aSortBlock.
	self list: self list!

clear
	"Remove all contents in the receiver's model"

	self model removeAll!

defaultSortBlock
	"Private - Answer a default sort block to use when the receiver is sorted"

	^Message selector: #<=!

isSorted
	"Answer true if the receiver is sorted by default"

	^self sortBlock notNil!

list 
	"Answer the contents of the receiver"

	^self model list!

list: aSequenceableCollection
	"Set the contents of the receiver to be aSequenceableCollection"

	| list |
	list := self isSorted
				ifTrue: 
					[aSequenceableCollection
						asSortedCollectionUsing: (self sortAlgorithmClass newSortBlock: self sortBlock)]
				ifFalse: [aSequenceableCollection].
	^self viewModel list: list!

onAboutToEditLabel: aLabelEditingEvent
	"An in-place edit is being initiated in the receiver's view. Forward back to the view."

	self view onAboutToEditLabel: aLabelEditingEvent!

onLabelOf: anObject editedTo: text
	"The receiver's element, anObject, has had its label edited in the receiver to the 
	specified text. Answer whether to accept the edited text."

	^self view onLabelOf: anObject editedTo: text!

selectableItems
	"Private - Answer the name of the <selectableItems> component that actually handles the selectable items in the receiver"
	
	^self view!

selectionByIndex
	"Answers the index of the selected object in the receiver or zero if there is none."
	
	^self selectableItems selectionByIndex!

selectionByIndex: anInteger
	"Select the object in the receiver with anInteger index."

	self selectableItems selectionByIndex: anInteger!

selectionByIndex: newSelection ifAbsent: exceptionHandler
	"Select the object identified by the <integer> index, newSelection, in the receiver. 
	If  newSelection is zero then all selections are cleared. "

	self selectableItems selectionByIndex: newSelection ifAbsent: exceptionHandler
!

selectionByIndexIfNone: exceptionHandler
	"Answer the index of the selected item in the list (1 based), or if no item is
	selected, then the result of evaluating the niladic valuable, exceptionHandler."

	^self selectableItems selectionByIndexIfNone: exceptionHandler
!

selectionsByIndex
	"Answer the indices of the selected objects in the receiver."

	^self selectableItems selectionsByIndex!

selectionsByIndex: aCollectionOfIntegers
	self selectableItems selectionsByIndex: aCollectionOfIntegers!

sortAlgorithmClass
	"Answer the class of algorithm to be used for sorting the receiver's contents. Use a stable sorting algorithm."

	^MergesortAlgorithm!

sortBlock
	^sortBlock!

sortBlock: anObject
	sortBlock := anObject! !

!UI.ListPresenter categoriesForMethods!
basicBeSorted!private!sorting! !
beNotSorted!public!sorting! !
beSorted!public!sorting! !
beSorted:!public!sorting! !
clear!operations!public! !
defaultSortBlock!constants!private!sorting! !
isSorted!public!sorting!testing! !
list!accessing!public! !
list:!accessing!public! !
onAboutToEditLabel:!event handling!public! !
onLabelOf:editedTo:!event handling!public! !
selectableItems!accessing!private! !
selectionByIndex!public!selection! !
selectionByIndex:!public!selection! !
selectionByIndex:ifAbsent:!public!selection! !
selectionByIndexIfNone:!public!selection! !
selectionsByIndex!public!selection! !
selectionsByIndex:!public!selection! !
sortAlgorithmClass!accessing!public! !
sortBlock!accessing!private!sorting! !
sortBlock:!accessing!private!sorting! !
!

UI.ListPresenter methodProtocol: #indexSelectableItems attributes: #(#readOnly) selectors: #(#selectionByIndex #selectionByIndex: #selectionByIndex:ifAbsent: #selectionByIndexIfNone:)!
UI.ListPresenter methodProtocol: #listPresenter attributes: #(#readOnly) selectors: #(#ensureVisible #list #list: #onAboutToDisplayMenu: #onActionPerformed #onCloseRequested #onIdleEntered #onInputMaskRequired: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onKillFocus #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMouseMoved: #onPositionChanged: #onPositionChanging: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSetFocus #onTipTextRequired: #onViewClosed #onViewOpened #parentPresenter #performAction #setFocus #show #topShell #view)!

!UI.ListPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^ListModel new!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Combo_box
	"Answer the literal data from which the 'Combo box' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Combo_box)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ComboBox} 38 #{Core.Array} 17 nil nil 50 2 8 1412498946 1025 32 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 32 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() 401 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 402 251 51 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 124 12 0 0 35 0 0 0] 8 #() 402 193 193 nil 27)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ListBox} 38 #{Core.Array} 17 nil nil 50 2 8 1412497665 1025 32 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 32 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() false 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 402 251 351 32 354 #horizontalExtent: 8 #(0) 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 124 12 0 0 185 0 0 0] 8 #() 402 193 193 nil 27)!

resource_Drop_down_list
	"Answer the literal data from which the 'Drop down list' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Drop_down_list)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ComboBox} 38 #{Core.Array} 17 nil nil 50 2 8 1412498947 1025 32 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 32 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() 401 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 402 251 51 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 124 12 0 0 35 0 0 0] 8 #() 402 193 193 nil 27)! !

!UI.ListPresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Combo_box!public!resources-views! !
resource_Default_view!public!resources-views! !
resource_Drop_down_list!public!resources-views! !
!

