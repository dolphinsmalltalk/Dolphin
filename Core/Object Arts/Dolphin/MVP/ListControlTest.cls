"Filed out from Dolphin Smalltalk 7"!

SelectableListItemsTest subclass: #ListControlTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ListControlTest guid: (GUID fromString: '{a10a1ba0-5afc-41f3-8b51-2b9e52718424}')!
ListControlTest isAbstract: true!
ListControlTest comment: ''!
!ListControlTest categoriesForClass!Unclassified! !
!ListControlTest methodsFor!

assertCaretVisible
	| pos view |
	view := presenter view.
	pos := (view itemRect: view caretIndex) origin.
	self assert: (view rectangle containsPoint: pos)!

isMultiSelect
	"Private - Is this a test of a list control in multi-select mode?"

	^presenter view isMultiSelect!

mouseDownEventOnItem: itemIndex buttons: anArray
	| mouseButton keys position |
	mouseButton := anArray intersection: #(#left #right #middle).
	self assert: mouseButton size equals: 1.
	mouseButton := mouseButton anyOne.
	keys := (anArray collect: [:each | MouseEvent wParamFlags at: each]) fold: [:a :b | a bitOr: b].
	position := itemIndex == 0
				ifTrue: [presenter clientExtent - (1 @ 1)]
				ifFalse: [(presenter itemRect: itemIndex) origin + (1 @ 1)].
	^MouseEvent
		window: presenter
		message: (##(IdentityDictionary new
				at: #left put: WM_LBUTTONDOWN;
				at: #right put: WM_RBUTTONDOWN;
				at: #middle put: WM_MBUTTONDOWN;
				yourself) at: mouseButton)
		wParam: keys
		lParam: position asDword!

newSelectionAfterLeftClickOutsideList: anArrayOfInteger 
	^self subclassResponsibility!

postClickEvent: aMouseEvent
	self assert: aMouseEvent isButtonDown.
	"Clear the message queue"
	SessionManager inputState pumpMessages.
	"Post a matched mouse down/up pair to the control"
	presenter view
		postMessage: aMouseEvent message
			wParam: aMouseEvent wParam
			lParam: aMouseEvent lParam;
		postMessage: aMouseEvent message + 1
			wParam: (aMouseEvent wParam maskClear: aMouseEvent buttonFlag)
			lParam: aMouseEvent lParam!

sendClickEvent: aMouseEvent
	self subclassResponsibility!

setUpForSelectionTesting
	presenter list: (1 to: 10) asOrderedCollection!

testLastSelectionCacheUpdatedOnRemove
	"#717"

	| objects |
	objects := self objectsToTest.
	presenter model addAll: objects.
	self assert: presenter hasSelection not.
	presenter selection: objects second.
	self assert: presenter lastSelIndices equals: #(2).
	presenter model removeAtIndex: 1.
	self assert: presenter lastSelIndices equals: #(1).
	"Remainder of the test is for multi-select mode only"
	self isMultiSelect ifFalse: [^self].
	presenter selectionsByIndex: #(2 4).
	self assert: presenter lastSelIndices equals: #(2 4).
	self
		shouldnt: 
			[presenter model removeAll: (Array with: presenter model first with: (presenter model at: 3))]
		triggerAnyOf: #(#selectionChanging: #selectionChanged)
		against: presenter.
	self assert: presenter lastSelIndices equals: #(1 2).
	self
		should: [presenter model removeAll: presenter model copy]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter lastSelIndices equals: #().
	presenter model addAll: self objectsToTest.
	presenter selectionsByIndex: #(1 3 5).
	self assert: presenter lastSelIndices equals: #(1 3 5).
	self
		should: [presenter model remove: presenter model last]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter lastSelIndices equals: #(1 3)!

testNewSelectionsClickOutsideListWithModifiers
	"ListView and ListBox behaviour differs"

	self subclassResponsibility!

testNewSelectionsCtrlClickOnSelectedItem
	| event expected |
	self setUpForSelectionTesting.
	presenter selectionsByIndex: #(1 3).
	event := self mouseDownEventOnItem: 1 buttons: #(#left #control).
	"Ctrl-click over selected item makes no different in single-select mode"
	expected := {self isMultiSelect ifTrue: [3] ifFalse: [1]}.
	self verifyNewSelectionsFromEvent: event equals: expected.
	presenter selectionsByIndex: #(1).
	self isMultiSelect ifTrue: [expected := #()].
	self verifyNewSelectionsFromEvent: event equals: expected!

testNewSelectionsCtrlClickOnUnselectedItem
	| event expected |
	self setUpForSelectionTesting.
	event := self mouseDownEventOnItem: 1 buttons: #(#left #control).
	self verifyNewSelectionsFromEvent: event equals: #(1).
	presenter selectionsByIndex: #(3).
	expected := self isMultiSelect ifTrue: [#(1 3)] ifFalse: [#(1)].
	self verifyNewSelectionsFromEvent: event equals: expected!

testNewSelectionsInitialShiftClick
	| event |
	self setUpForSelectionTesting.
	event := self mouseDownEventOnItem: 1 buttons: #(#left #shift).
	self verifyNewSelectionsFromEvent: event equals: #(1).
	"Note that we have to clear the anchorIndex to reset to 'initial' state where a shift-click in a multi-select list will only select the clicked item and not a range. Unfortunately the only way to remove an existing anchor in a traditional ListBox is to delete the item. LB_SETANCHORINDEX returns LB_ERR when passed 0. The equivalent ListView operation to clear the anchor does work and is necessary because deleting the item does not remove the anchor. So we do both."
	presenter model removeAtIndex: 1.
	presenter view anchorIndex: 0.
	event := self mouseDownEventOnItem: 3 buttons: #(#left #shift).
	self verifyNewSelectionsFromEvent: event equals: #(3)!

testNewSelectionsLeftClickOutsideList
	| event |
	self setUpForSelectionTesting.
	event := self mouseDownEventOnItem: 0 buttons: #(#left).
	self verifyNewSelectionsFromEvent: event equals: #().
	presenter selectionsByIndex: #(3).
	self verifyNewSelectionsFromEvent: event equals: (self newSelectionAfterLeftClickOutsideList: #(3))!

testNewSelectionsNonLeftClicksWithModifiers
	"Single selection ListView will always change the selection for right button clicks, regardless of modifiers"

	| selections |
	self setUpForSelectionTesting.
	presenter selectionsByIndex: #(1 3 5).
	selections := presenter selectionsByIndex.
	"Right or middle clicks with any modifiers will never modify the selection. Just cover a few example cases."
	#(#(4 #(#right #control)) #(2 #(#middle #shift)) #(3 #(#right #control #shift)) #(0 #(#middle #control)))
		do: 
			[:pair |
			| event expected |
			event := self mouseDownEventOnItem: pair first buttons: pair second.
			expected := (event isRButtonDown and: [self isMultiSelect not])
						ifTrue: [{pair first}]
						ifFalse: [selections].
			self verifyNewSelectionsFromEvent: event equals: expected.
			selections := expected]!

testNewSelectionsRightClickOutsideSelection
	| event |
	self setUpForSelectionTesting.
	presenter selectionsByIndex: #(1 3 5).
	event := self mouseDownEventOnItem: 2 buttons: #(#right).
	self verifyNewSelectionsFromEvent: event equals: #(2)!

testNewSelectionsRightClickWithinSelection
	| event selections |
	self setUpForSelectionTesting.
	presenter selectionsByIndex: #(3 5).
	selections := presenter selectionsByIndex.
	event := self mouseDownEventOnItem: 3 buttons: #(#right).
	self verifyNewSelectionsFromEvent: event equals: selections!

testNewSelectionsSimpleLeftClick
	| event |
	self setUpForSelectionTesting.
	event := self mouseDownEventOnItem: 1 buttons: #(#left).
	self verifyNewSelectionsFromEvent: event equals: #(1).
	presenter selectionsByIndex: #(3).
	self verifyNewSelectionsFromEvent: event equals: #(1)!

testProgrammaticSelectionVisible
	"#1381"

	"Note that the last selection is the one with the caret, and therefore it is that which should be visible"

	| view |
	view := presenter view.
	view list: (0 to: 100) asOrderedCollection.
	#(#(100) #(50 100) #(100 50) #(1)) do: 
			[:each | 
			view selections: each.
			self assertCaretVisible]!

testSelectionsByIndex
	self isMultiSelect
		ifTrue: [self verifyMultiSelectionsByIndex]
		ifFalse: [self verifySingleSelectionsByIndex]!

verifyMultiSelectionsByIndex
	| objects sel |
	objects := self objectsToTest.
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
	self assert: presenter selectionsByIndex equals: sel!

verifyNewSelectionsFromEvent: aMouseEvent equals: anArray
	self sendClickEvent: aMouseEvent.
	self assert: presenter view selectionsByIndex equals: anArray!

verifySingleSelectionsByIndex
	| objects sel |
	objects := self objectsToTest.
	self deny: self isMultiSelect.
	presenter model addAll: objects.
	"Select a single object"
	sel := {1}.
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
	"Selecting a pair including the existing selection, but as that is first this is not a selection change."
	sel := {1. objects size}.
	self
		shouldnt: [presenter selectionsByIndex: sel]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selectionsByIndex equals: {sel first}.
	"Selecting a different pair not including the existing single selection is a selection change"
	sel := {2. objects size}.
	self
		should: [presenter selectionsByIndex: sel]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selectionsByIndex equals: {sel first}.
	self
		shouldnt: [presenter selectionsByIndex: sel]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selectionsByIndex equals: {sel first}.	"#selectionByIndex: (singular) of the same selection should still be a no-op"
	self
		shouldnt: [presenter selectionByIndex: sel first]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selectionsByIndex equals: {sel first}.
	"#selectionByIndex: of the same different selection should change"
	self
		should: [presenter selectionByIndex: 3]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selectionsByIndex equals: {3}.
	"Empty selection"
	self
		should: [presenter selectionsByIndex: #()]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selectionsByIndex equals: #().
	self
		shouldnt: [presenter selectionsByIndex: #()]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selectionsByIndex equals: #()! !
!ListControlTest categoriesFor: #assertCaretVisible!helpers!private! !
!ListControlTest categoriesFor: #isMultiSelect!private!testing! !
!ListControlTest categoriesFor: #mouseDownEventOnItem:buttons:!helpers!private! !
!ListControlTest categoriesFor: #newSelectionAfterLeftClickOutsideList:!constants!private! !
!ListControlTest categoriesFor: #postClickEvent:!helpers!private! !
!ListControlTest categoriesFor: #sendClickEvent:!helpers!private! !
!ListControlTest categoriesFor: #setUpForSelectionTesting!helpers!private! !
!ListControlTest categoriesFor: #testLastSelectionCacheUpdatedOnRemove!public!unit tests! !
!ListControlTest categoriesFor: #testNewSelectionsClickOutsideListWithModifiers!public!unit tests! !
!ListControlTest categoriesFor: #testNewSelectionsCtrlClickOnSelectedItem!public!unit tests! !
!ListControlTest categoriesFor: #testNewSelectionsCtrlClickOnUnselectedItem!public!unit tests! !
!ListControlTest categoriesFor: #testNewSelectionsInitialShiftClick!public!unit tests! !
!ListControlTest categoriesFor: #testNewSelectionsLeftClickOutsideList!public!unit tests! !
!ListControlTest categoriesFor: #testNewSelectionsNonLeftClicksWithModifiers!public!unit tests! !
!ListControlTest categoriesFor: #testNewSelectionsRightClickOutsideSelection!public!unit tests! !
!ListControlTest categoriesFor: #testNewSelectionsRightClickWithinSelection!public!unit tests! !
!ListControlTest categoriesFor: #testNewSelectionsSimpleLeftClick!public!unit tests! !
!ListControlTest categoriesFor: #testProgrammaticSelectionVisible!public!unit tests! !
!ListControlTest categoriesFor: #testSelectionsByIndex!public!unit tests! !
!ListControlTest categoriesFor: #verifyMultiSelectionsByIndex!helpers!private! !
!ListControlTest categoriesFor: #verifyNewSelectionsFromEvent:equals:!helpers!private! !
!ListControlTest categoriesFor: #verifySingleSelectionsByIndex!helpers!private! !

