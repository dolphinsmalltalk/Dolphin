"Filed out from Dolphin Smalltalk"!

UI.Tests.SelectableListItemsTest
	subclass: #'UI.Tests.ListControlTest'
	instanceVariableNames: 'clicks'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ListControlTest guid: (Core.GUID fromString: '{a10a1ba0-5afc-41f3-8b51-2b9e52718424}')!
UI.Tests.ListControlTest isNonInstantiable: true!
UI.Tests.ListControlTest comment: ''!
!UI.Tests.ListControlTest methodsFor!

assertCaretVisible
	| pos view |
	view := presenter view.
	pos := (view itemRect: view caretIndex) origin.
	self assert: (view rectangle containsPoint: pos)!

expectedSelectionsForSendShiftClickTests
	^self isMultiSelect ifTrue: [#(2 3 4)] ifFalse: [#(4)]!

isMultiSelect
	"Private - Is this a test of a list control in multi-select mode?"

	^presenter view isMultiSelect!

newSelectionAfterLeftClickOutsideList: anArrayOfInteger 
	^self subclassResponsibility!

setupClickIntercept
	^self subclassResponsibility!

setUpForSelectionEventTesting
	"The ListView (and other selectable item views) should really be generating a #selectionChanged: event with a SelectionChangedEvent parameter, but at present they don't"

	self setUpForSelectionTesting.
	self observeSelectionEvents.
	self setupClickTimeout.
	clicks := OrderedCollection new.
	self setupClickIntercept!

setUpForSelectionTesting
	presenter list: (1 to: 10) asOrderedCollection!

testEventsFromClickSelectionChange
	"Test that the expected sequence of selection events are raised for left-click selection when the selectionChanging: event is rejected but without a prompt so the control still receives the mouse up."

	| decision |
	self setUpForSelectionEventTesting.
	decision := false.
	selectionChanging := 
			[:selChanging |
			events addLast: selChanging.
			selChanging value: decision].
	self verifyEventsFromClickSelectionChangeRejected: #left.
	decision := true.
	self verifyEventsFromClickSelectionChangeAccepted: #left!

testEventsFromClickSelectionChangePrompted
	"Test that the expected sequence of selection events are raised for left-click selection, simulating the selectionChanging: event being refused by user in response to a prompt so the control does not receive the mouse up associated with the actual click."

	| decision |
	self setUpForSelectionEventTesting.
	decision := false.
	selectionChanging := 
			[:selChanging |
			| msg |
			events addLast: selChanging.
			"Snaffle the mouse up as the control will lose focus/activation as soon as the prompt is opened"
			msg := MSG new.
			User32
				getMessage: msg
				hWnd: presenter view handle
				wMsgFilterMin: WM_LBUTTONUP
				wMsgFilterMax: WM_LBUTTONUP.
			"Confirm or refuse the selection change"
			selChanging value: decision].
	self verifyEventsFromClickSelectionChangeRejected: #left.
	decision := true.
	self verifyEventsFromClickSelectionChangeAccepted: #left!

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
		shouldnt: [presenter model removeAll: {presenter model first. presenter model at: 3}]
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

testNewSelectionNonLeftClicks
	| event selections |
	self setUpForSelectionTesting.
	presenter selectionsByIndex: #(1 3 5).
	event := self mouseDownEventOnItem: 2 buttons: #(#right).
	self verifySelectionsFromMouseDown: event equals: #(2).
	presenter selectionsByIndex: #(3 5).
	selections := presenter selectionsByIndex.
	event := self mouseDownEventOnItem: 3 buttons: #(#right).
	self verifySelectionsFromMouseDown: event equals: selections.
	presenter selectionsByIndex: #(1 3 5).
	selections := presenter selectionsByIndex.
	"Right or middle clicks with any modifiers will never modify the selection. Just cover a few example cases."
	#(#(4 #(#right #control)) #(2 #(#middle #shift)) #(3 #(#right #control #shift)) #(0 #(#middle #control)))
		do: 
			[:pair |
			| mouseDown expected |
			mouseDown := self mouseDownEventOnItem: pair first buttons: pair second.
			expected := (mouseDown isRButtonDown and: [self isMultiSelect not])
						ifTrue: [{pair first}]
						ifFalse: [selections].
			self verifySelectionsFromMouseDown: mouseDown equals: expected.
			selections := expected]!

testNewSelectionsBasicLeftClicks
	"Tests left-click on an item changes selection, and left-click in no-mans land."

	| event inNoMansLand |
	self setUpForSelectionTesting.
	inNoMansLand := self mouseDownEventOnItem: 0 buttons: #(#left).
	self verifySelectionsFromMouseDown: inNoMansLand equals: #().
	event := self mouseDownEventOnItem: 1 buttons: #(#left).
	self verifySelectionsFromMouseDown: event equals: #(1).
	presenter selectionsByIndex: #(3).
	self verifySelectionsFromMouseDown: event equals: #(1).
	self verifySelectionsFromMouseDown: inNoMansLand
		equals: (self newSelectionAfterLeftClickOutsideList: #(1))!

testNewSelectionsClickOutsideListWithModifiers
	"ListView and ListBox behaviour differs"

	self subclassResponsibility!

testNewSelectionsCtrlLeftClick
	| event expected |
	self setUpForSelectionTesting.
	event := self mouseDownEventOnItem: 1 buttons: #(#left #control).
	self verifySelectionsFromMouseDown: event equals: #(1).
	presenter selectionsByIndex: #(3).
	expected := self isMultiSelect ifTrue: [#(1 3)] ifFalse: [#(1)].
	self verifySelectionsFromMouseDown: event equals: expected.
	"Ctrl-click over selected item makes no different in single-select mode"
	expected := {self isMultiSelect ifTrue: [3] ifFalse: [1]}.
	self verifySelectionsFromMouseDown: event equals: expected.
	presenter selectionsByIndex: #(1).
	self isMultiSelect ifTrue: [expected := #()].
	self verifySelectionsFromMouseDown: event equals: expected!

testNewSelectionsInitialShiftClick
	| event |
	self setUpForSelectionTesting.
	event := self mouseDownEventOnItem: 1 buttons: #(#left #shift).
	self verifySelectionsFromMouseDown: event equals: #(1).
	"Note that we have to clear the anchorIndex to reset to 'initial' state where a shift-click in a multi-select list will only select the clicked item and not a range. Unfortunately the only way to remove an existing anchor in a traditional ListBox is to delete the item. LB_SETANCHORINDEX returns LB_ERR when passed 0. The equivalent ListView operation to clear the anchor does work and is necessary because deleting the item does not remove the anchor. So we do both."
	presenter model removeAtIndex: 1.
	presenter view anchorIndex: 0.
	event := self mouseDownEventOnItem: 3 buttons: #(#left #shift).
	self verifySelectionsFromMouseDown: event equals: #(3)!

testProgrammaticSelectionVisible
	"#1381"

	"Note that the last selection is the one with the caret, and therefore it is that which should be visible"

	| view |
	view := presenter view.
	view list: (0 to: 100).
	#(#(100) #(50 100) #(100 50) #(1)) do: 
			[:each | 
			view selections: each.
			self assertCaretVisible]!

testSelectionsByIndex
	self isMultiSelect
		ifTrue: [self verifyMultiSelectionsByIndex]
		ifFalse: [self verifySingleSelectionsByIndex]!

testSelectionsPreservedOnRecreate
	| selections |
	self setUpForSelectionTesting.
	presenter selectionsByIndex: (1 to: 10 by: 2).
	selections := presenter selectionsByIndex.
	presenter recreate.
	"Verify actual selections restored"
	self assert: presenter getSelectionsByIndex equals: selections.
	"Verify cached selections retained"
	self assert: presenter selectionsByIndex equals: selections.


	!

verifyClicks: anArray
	self subclassResponsibility!

verifyEventsFromClickSelectionChangeAccepted: aSymbol
	| changed changing event |
	presenter view selectionsByIndex: #().
	events := OrderedCollection new.
	clicks := OrderedCollection new.
	event := self mouseDownEventOnItem: 2 buttons: {aSymbol}.
	self sendClickEvent: event.
	self assert: events size equals: 2.
	changing := events first.
	self assert: changing isKindOf: SelectionChangingEvent.
	self assert: changing oldSelections equals: #().
	self assert: changing newSelections equals: #(2).
	changed := events last.
	self assert: changed isKindOf: SelectionChangedEvent.
	self assert: changed newSelections equals: #(2).
	self verifyClicks: {{2. event position}}.
	"Send a shift-<button>-click event over a subsequent item."
	events := OrderedCollection new.
	clicks := OrderedCollection new.
	event := self mouseDownEventOnItem: 4 buttons: {aSymbol. #shift}.
	self sendClickEvent: event.
	self assert: events size equals: 2.
	changing := events first.
	self assert: changing isKindOf: SelectionChangingEvent.
	self assert: changing oldSelections equals: #(2).
	self assert: changing newSelections equals: self expectedSelectionsForSendShiftClickTests.
	changed := events last.
	self assert: changed isKindOf: SelectionChangedEvent.
	self assert: changed newSelections equals: self expectedSelectionsForSendShiftClickTests.
	self verifyClicks: {{4. event position}}!

verifyEventsFromClickSelectionChangeRejected: aSymbol
	| event changing |
	events := OrderedCollection new.
	clicks := OrderedCollection new.
	event := self mouseDownEventOnItem: 2 buttons: {aSymbol}.
	self sendClickEvent: event.
	self assert: events size equals: 1.
	changing := events first.
	self assert: changing isKindOf: SelectionChangingEvent.
	self assert: changing oldSelections equals: #().
	self assert: changing newSelections equals: #(2).
	"Because we didn't forward the button down event to the control, there should be no click notification."
	self assert: clicks size equals: 0.
	"Ensure there is a selection and then send a shift-<button>-click event over a subsequent item."
	presenter view selectionByIndex: 2.
	events := OrderedCollection new.
	clicks := OrderedCollection new.
	event := self mouseDownEventOnItem: 4 buttons: {aSymbol. #shift}.
	self sendClickEvent: event.
	self assert: events size equals: 1.
	changing := events first.
	self assert: changing isKindOf: SelectionChangingEvent.
	self assert: changing oldSelections equals: #(2).
	self assert: changing newSelections equals: self expectedSelectionsForSendShiftClickTests.
	self assert: clicks size equals: 0!

verifyMultiSelectionsByIndex
	| objects sel |
	objects := self objectsToTest.
	presenter model addAll: objects.
	"Select a single object"
	sel := {objects size}.
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
	sel := {1. objects size}.
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
	sel := {2. objects size - 1}.
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

verifySelectionsFromMouseDown: aMouseEvent equals: anArray
	"Test the predicted selection..."
	self assert: (presenter newSelectionsFromEvent: aMouseEvent) equals: anArray description: 'Predicted selections mismatch'.
	self sendClickEvent: aMouseEvent.
	"... and that the control did actually select the expected item(s)"
	self assert: presenter getSelectionsByIndex equals: anArray description: 'Actual selections mismatch'.
	"... and the selection cache was updated"
	self assert: presenter selectionsByIndex equals: anArray description: 'Cached selections mismatch'!

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
!UI.Tests.ListControlTest categoriesForMethods!
assertCaretVisible!helpers!private! !
expectedSelectionsForSendShiftClickTests!constants!private! !
isMultiSelect!private!testing! !
newSelectionAfterLeftClickOutsideList:!constants!private! !
setupClickIntercept!helpers!private! !
setUpForSelectionEventTesting!helpers!private! !
setUpForSelectionTesting!helpers!private! !
testEventsFromClickSelectionChange!public!unit tests! !
testEventsFromClickSelectionChangePrompted!public!unit tests! !
testLastSelectionCacheUpdatedOnRemove!public!unit tests! !
testNewSelectionNonLeftClicks!public!unit tests! !
testNewSelectionsBasicLeftClicks!public!unit tests! !
testNewSelectionsClickOutsideListWithModifiers!public!unit tests! !
testNewSelectionsCtrlLeftClick!public!unit tests! !
testNewSelectionsInitialShiftClick!public!unit tests! !
testProgrammaticSelectionVisible!public!unit tests! !
testSelectionsByIndex!public!unit tests! !
testSelectionsPreservedOnRecreate!public!unit tests! !
verifyClicks:!helpers!private! !
verifyEventsFromClickSelectionChangeAccepted:!helpers!private! !
verifyEventsFromClickSelectionChangeRejected:!helpers!private! !
verifyMultiSelectionsByIndex!helpers!private! !
verifySelectionsFromMouseDown:equals:!helpers!private! !
verifySingleSelectionsByIndex!helpers!private! !
!

