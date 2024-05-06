"Filed out from Dolphin Smalltalk"!

SelectableItemsPresenter subclass: #ListPresenter
	instanceVariableNames: 'sortBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ListPresenter guid: (GUID fromString: '{87b4c685-026e-11d3-9fd7-00a0cc3e4a32}')!

ListPresenter comment: 'ListPresenter implements a <listPresenter> component that can be used to display the contents of a <listModel> within a <listView>.  It also conforms to <selectableItems> and <indexSelectableItems> to provide methods for accessing the current selection(s) in the list.

Instance Variables:
	sortBlock		<dyadicValuable> or nil, specifying how a objects should be sorted.



'!

!ListPresenter categoriesForClass!MVP-Presenters! !

!ListPresenter methodsFor!

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

onAboutToEditLabel: anObject
	"The receiver's element, anObject, is about to have its label edited in the receiver.
	Forward back to the view."

	^self view onAboutToEditLabel: anObject!

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
	"Answer the index of the selectd item in the list (1 based), or if no item is
	selected, then the result of evaluating the niladic valuable, exceptionHandler."

	^self selectableItems selectionByIndexIfNone: exceptionHandler
!

selectionsByIndex
	"Answer the indices of the selected objects in the receiver>"

	^self selectableItems selectionsByIndex!

sortAlgorithmClass
	"Answer the class of algorithm to be used for sorting the receiver's contents. Use a stable sorting algorithm."

	^MergesortAlgorithm!

sortBlock
	^sortBlock!

sortBlock: anObject
	sortBlock := anObject! !

!ListPresenter categoriesForMethods!
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
sortAlgorithmClass!accessing!public! !
sortBlock!accessing!private!sorting! !
sortBlock:!accessing!private!sorting! !
!

ListPresenter methodProtocol: #indexSelectableItems attributes: #(#readOnly) selectors: #(#selectionByIndex #selectionByIndex: #selectionByIndex:ifAbsent: #selectionByIndexIfNone:)!
ListPresenter methodProtocol: #listPresenter attributes: #(#readOnly) selectors: #(#ensureVisible #list #list: #onAboutToDisplayMenu: #onActionPerformed #onCloseRequested #onIdleEntered #onInputMaskRequired: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onKillFocus #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMouseMoved: #onPositionChanged: #onPositionChanging: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSetFocus #onTipTextRequired: #onViewClosed #onViewOpened #parentPresenter #performAction #setFocus #show #topShell #view)!

!ListPresenter class methodsFor!

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Combo_box)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ComboBox) 34 17 nil nil 34 2 8 1412498946 1025 416 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 8 1903738896 459270 ##(Smalltalk.Message) #displayString 8 #() 528 401 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 786 251 51 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 252 7 0 0 35 0 0 0] 8 #() 786 193 193 nil 27 )!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ListBox) 34 17 nil nil 34 2 8 1412497665 1025 416 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 8 1903732064 459270 ##(Smalltalk.Message) #displayString 8 #() 528 false 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 786 251 351 416 738 #horizontalExtent: 8 #(0) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 252 7 0 0 185 0 0 0] 8 #() 786 193 193 nil 27 )!

resource_Drop_down_list
	"Answer the literal data from which the 'Drop down list' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Drop_down_list)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ComboBox) 34 17 nil nil 34 2 8 1412498947 1025 416 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 8 1903738896 459270 ##(Smalltalk.Message) #displayString 8 #() 528 401 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 786 251 51 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 252 7 0 0 35 0 0 0] 8 #() 786 193 193 nil 27 )! !

!ListPresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Combo_box!public!resources-views! !
resource_Default_view!public!resources-views! !
resource_Drop_down_list!public!resources-views! !
!

