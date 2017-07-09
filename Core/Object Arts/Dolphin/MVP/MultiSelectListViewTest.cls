"Filed out from Dolphin Smalltalk 7"!

ListViewTest subclass: #MultiSelectListViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MultiSelectListViewTest guid: (GUID fromString: '{67f073df-d832-4f4f-a5c1-57d8730e3515}')!
MultiSelectListViewTest comment: ''!
!MultiSelectListViewTest categoriesForClass!Unclassified! !
!MultiSelectListViewTest methodsFor!

initializePresenter
	super initializePresenter.
	presenter view isMultiSelect: true!

sortSelections
	^#(49 50)!

testNewSelectionsClickOutsideListWithModifiers
	| event |
	self setUpForSelectionTesting.
	presenter selectionsByIndex: #(1).
	(OrderedCollection new)
		add: #(#control);
		add: #(#shift);
		add: #(#control #shift);
		do: 
				[:modifiers |
				event := self mouseDownEventOnItem: 0 buttons: (modifiers copyWith: #left).
				self assert: (presenter newSelectionsFromEvent: event) = #(1)].!

testNewSelectionsCtrlClickOnSelectedItem
	| event |
	self setUpForSelectionTesting.
	presenter selectionsByIndex: #(1 3).
	event := self mouseDownEventOnItem: 1 buttons: #(#left #control).
	self assert: (presenter newSelectionsFromEvent: event) = #(3).
	presenter selectionsByIndex: #(1).
	self assert: (presenter newSelectionsFromEvent: event) = #().!

testNewSelectionsCtrlClickOnUnselectedItem
	| event |
	self setUpForSelectionTesting.
	event := self mouseDownEventOnItem: 1 buttons: #(#left #control).
	self assert: (presenter newSelectionsFromEvent: event) = #(1).
	presenter selectionsByIndex: #(3).
	self assert: (presenter newSelectionsFromEvent: event) = #(1 3).!

testNewSelectionsCtrlShiftClickAdditive
	| event |
	self setUpForSelectionTesting.
	presenter
		selectionsByIndex: #(1 3);
		anchorIndex: 3.
	event := self mouseDownEventOnItem: 7 buttons: #(#left #control #shift).
	self assert: (presenter newSelectionsFromEvent: event) = #(1 3 4 5 6 7).
	presenter selectionsByIndex: #(1 3 5 7).
	"Programatically changing selection does not change the anchor."
	self assert: presenter anchorIndex = 3.
	self assert: (presenter newSelectionsFromEvent: event) = #(1 3 4 5 6 7).!

testNewSelectionsCtrlShiftClickSubtractive
	| event |
	self setUpForSelectionTesting.
	presenter
		selectionsByIndex: #(1 2 3 4 5 7);
		anchorIndex: 6.
	event := self mouseDownEventOnItem: 2 buttons: #(#left #control #shift).
	"In Windows Explorer and other applications that use ListView or a similar control,
	(2) would not be selected at this point. Why is it in Dolphin?
	(See comment at the end of #newSelectionsFromEvent:.)"
	self assert: (presenter newSelectionsFromEvent: event) = #(1 2 7).
	presenter selectionsByIndex: #(1 3 5 7).
	self assert: (presenter newSelectionsFromEvent: event) = #(1 2 7).!

testNewSelectionsInitialShiftClick
	| event |
	self setUpForSelectionTesting.
	event := self mouseDownEventOnItem: 1 buttons: #(#left #shift).
	self assert: (presenter newSelectionsFromEvent: event) = #(1).
	event := self mouseDownEventOnItem: 3 buttons: #(#left #shift).
	self assert: (presenter newSelectionsFromEvent: event) = #(3).!

testNewSelectionsNonLeftClicksWithModifiers
	self setUpForSelectionTesting.
	presenter selectionsByIndex: #(1 3 5).
	"Right or middle clicks with any modifiers will never modify the selection. Just cover a few example cases."
	(OrderedCollection new)
		add: 1 -> #(#right #control);
		add: 2 -> #(#middle #shift);
		add: 3 -> #(#right #control #shift);
		add: 0 -> #(#middle #control);
		do: 
				[:assoc |
				| event |
				event := self mouseDownEventOnItem: assoc key buttons: assoc value.
				self assert: (presenter newSelectionsFromEvent: event) = #(1 3 5)].!

testNewSelectionsRightClickOutsideSelection
	| event |
	self setUpForSelectionTesting.
	presenter selectionsByIndex: #(1 3 5).
	event := self mouseDownEventOnItem: 2 buttons: #(#right).
	self assert: (presenter newSelectionsFromEvent: event) = #(2).!

testNewSelectionsRightClickWithinSelection
	| event |
	self setUpForSelectionTesting.
	presenter selectionsByIndex: #(1 3 5).
	event := self mouseDownEventOnItem: 3 buttons: #(#right).
	self assert: (presenter newSelectionsFromEvent: event) = #(1 3 5).!

testNewSelectionsShiftClickWithSelectionMark
	| event |
	self setUpForSelectionTesting.
	presenter anchorIndex: 3.
	event := self mouseDownEventOnItem: 5 buttons: #(#left #shift).
	"It does not really matter what is currently selected, only what is marked and what is clicked"
	(OrderedCollection new)
		add: #();
		add: #(3);
		add: #(1 2 3);
		add: #(3 4 5 6);
		do: 
				[:oldSelections |
				presenter selectionsByIndex: oldSelections.
				self assert: (presenter newSelectionsFromEvent: event) = #(3 4 5)].
	event := self mouseDownEventOnItem: 3 buttons: #(#left #shift).
	self assert: (presenter newSelectionsFromEvent: event) = #(3).!

testSelectionsByIndex
	| objects sel |
	objects := self objectsToTest.
	presenter view isMultiSelect: true.
	presenter model addAll: objects.
	"Select a single object"
	sel := Array with: objects size.
	self
		should: [presenter selectionsByIndex: sel]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selectionsByIndex equals: sel.
	"Selecting same element should be a no-op"
	self
		shouldnt: [presenter selectionsByIndex: sel]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selectionsByIndex equals: sel.
	"Selecting a pair including the existing selection"
	sel := Array with: 1 with: objects size.
	self
		should: [presenter selectionsByIndex: sel]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selectionsByIndex equals: sel.
	"Selecting same pair should be a no-op"
	self
		shouldnt: [presenter selectionsByIndex: sel]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selectionsByIndex equals: sel.
	"Selecting single item from existing selection should remove other selections"
	sel := #(1).
	self
		should: [presenter selectionsByIndex: sel]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selectionsByIndex equals: sel.
	"Selecting a different pair not including the existing single selection"
	sel := Array with: 2 with: objects size - 1.
	self
		should: [presenter selectionsByIndex: sel]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selectionsByIndex equals: sel.
	"#selectionByIndex: should also clear other selections"
	sel := sel copyFrom: 2.
	self
		should: [presenter selectionByIndex: sel first]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selectionsByIndex equals: sel! !
!MultiSelectListViewTest categoriesFor: #initializePresenter!public!Running! !
!MultiSelectListViewTest categoriesFor: #sortSelections!private!unit tests! !
!MultiSelectListViewTest categoriesFor: #testNewSelectionsClickOutsideListWithModifiers!public!unit tests! !
!MultiSelectListViewTest categoriesFor: #testNewSelectionsCtrlClickOnSelectedItem!public!unit tests! !
!MultiSelectListViewTest categoriesFor: #testNewSelectionsCtrlClickOnUnselectedItem!public!unit tests! !
!MultiSelectListViewTest categoriesFor: #testNewSelectionsCtrlShiftClickAdditive!public!unit tests! !
!MultiSelectListViewTest categoriesFor: #testNewSelectionsCtrlShiftClickSubtractive!public!unit tests! !
!MultiSelectListViewTest categoriesFor: #testNewSelectionsInitialShiftClick!public!unit tests! !
!MultiSelectListViewTest categoriesFor: #testNewSelectionsNonLeftClicksWithModifiers!public!unit tests! !
!MultiSelectListViewTest categoriesFor: #testNewSelectionsRightClickOutsideSelection!public!unit tests! !
!MultiSelectListViewTest categoriesFor: #testNewSelectionsRightClickWithinSelection!public!unit tests! !
!MultiSelectListViewTest categoriesFor: #testNewSelectionsShiftClickWithSelectionMark!public!unit tests! !
!MultiSelectListViewTest categoriesFor: #testSelectionsByIndex!public!unit tests! !

