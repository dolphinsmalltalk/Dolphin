"Filed out from Dolphin Smalltalk"!

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

marqueeSelectionEventsToItem: anInteger
	| downEvent targetPos mouseEvents x |
	downEvent := self mouseDownEventOnItem: 0 buttons: {#left}.
	targetPos := (presenter itemRect: anInteger) origin + 5.
	mouseEvents := Array writeStream.
	mouseEvents nextPut: downEvent.
	"It seems the minimum number of WM_MOUSEMOVEs we can get away with is two; one a small distance away from the start point, and another at the target position.
	Note that for mouse moves Windows updates the posted event to convert the co-ords to client co-ords, so we must supply them as screen co-ords)"
	mouseEvents nextPut: (MouseEvent
						window: presenter
						message: WM_MOUSEMOVE
						wParam: downEvent wParam
						lParam: (presenter mapPointToScreen: downEvent position - 5) asDword).
	mouseEvents nextPut: (MouseEvent
						window: presenter
						message: WM_MOUSEMOVE
						wParam: downEvent wParam
						lParam: (presenter mapPointToScreen: targetPos) asDword).
	mouseEvents nextPut: ((self mouseUpForMouseDown: downEvent)
				lParam: targetPos asDword;
				yourself).
	^mouseEvents contents!

sortSelections
	^#(49 50)!

testEventsFromMarqueeSelectionChange
	"Test that the expected sequence of selection events are raised for left-click selection when the selectionChanging: event is rejected but without a prompt so the control still receives the mouse up."

	| decision changing mouseEvents changed |
	self setUpForSelectionEventTesting.
	decision := true.
	selectionChanging := 
			[:selChanging |
			events addLast: selChanging.
			selChanging value: decision].
	events := OrderedCollection new.
	clicks := OrderedCollection new.
	mouseEvents := self marqueeSelectionEventsToItem: 9.
	self sendMouseEvents: mouseEvents.
	"We allowed the selection change to proceed, so expect 2 events (as the initial selection was empty)"
	self assert: presenter selectionsByIndex equals: (9 to: 10).
	self assert: events size equals: 2.
	changing := events first.
	self assert: changing isKindOf: SelectionChangingEvent.
	self assert: changing oldSelections equals: #().
	self assert: changing newSelections equals: #(9 10).
	changed := events second.
	self assert: changed isKindOf: SelectionChangedEvent.
	self assert: clicks size equals: 1.

	"Now test marquee selection when there is an initial selection - in this case we get two selection changing events, one for the initial mouse down in no-mans land to clear all selections, and another for the eventual marquee selection."
	presenter view selectionByIndex: 8.
	events := OrderedCollection new.
	clicks := OrderedCollection new.
	self sendMouseEvents: mouseEvents.
	"We allowed the selection change to proceed, so expect 3 events (as the initial selection was not empty)"
	self assert: presenter selectionsByIndex equals: (9 to: 10).
	self assert: events size equals: 3.
	changing := events first.
	self assert: changing isKindOf: SelectionChangingEvent.
	self assert: changing oldSelections equals: #(8).
	self assert: changing newSelections equals: #().
	changing := events second.
	self assert: changing isKindOf: SelectionChangingEvent.
	self assert: changing oldSelections equals: #(8).
	self assert: changing newSelections equals: #(9 10).
	changed := events third.
	self assert: changed isKindOf: SelectionChangedEvent.
	self assert: clicks size equals: 1.

	"Now try refusing the change"
	presenter view selectionByIndex: 8.
	decision := false.
	events := OrderedCollection new.
	clicks := OrderedCollection new.
	self sendMouseEvents: mouseEvents.
	"We allowed the selection change to proceed, so expect 3 events (as the initial selection was not empty)"
	self assert: presenter selectionsByIndex equals: #(8).
	self assert: events size equals: 1.
	changing := events first.
	self assert: changing isKindOf: SelectionChangingEvent.
	self assert: changing oldSelections equals: #(8).
	self assert: changing newSelections equals: #().
	self assert: clicks size equals: 0.

	"Accept the 1st change, but not the 2nd"
	decision := true.
	selectionChanging := 
			[:selChanging |
			events addLast: selChanging.
			selChanging value: decision.
			decision := decision not].
	events := OrderedCollection new.
	clicks := OrderedCollection new.
	self sendMouseEvents: mouseEvents.
	"We prevented the selection change on 2nd asking, so expect 2 events"
	self assert: presenter selectionsByIndex equals: #(8).
	changing := events first.
	self assert: changing isKindOf: SelectionChangingEvent.
	self assert: changing oldSelections equals: #(8).
	self assert: changing newSelections equals: #().
	changing := events second.
	self assert: changing isKindOf: SelectionChangingEvent.
	self assert: changing oldSelections equals: #(8).
	self assert: changing newSelections equals: #(9 10).

!

testNewSelectionsCtrlShiftClickAdditive
	| event |
	self setUpForSelectionTesting.
	presenter
		selectionsByIndex: #(1 3);
		anchorIndex: 3.
	event := self mouseDownEventOnItem: 7 buttons: #(#left #control #shift).
	self verifySelectionsFromMouseDown: event equals: #(1 3 4 5 6 7).
	presenter selectionsByIndex: #(1 3 5 7).
	"Programatically changing selection does not change the anchor."
	self assert: presenter anchorIndex equals: 3.
	self verifySelectionsFromMouseDown: event equals: #(1 3 4 5 6 7)!

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
	self verifySelectionsFromMouseDown: event equals: #(1 2 7).
	presenter selectionsByIndex: #(1 3 5 7).
	self verifySelectionsFromMouseDown: event equals: #(1 2 7)!

testNewSelectionsShiftClickWithSelectionMark
	| event |
	self setUpForSelectionTesting.
	presenter anchorIndex: 3.
	event := self mouseDownEventOnItem: 5 buttons: #(#left #shift).
	"In a ListView it does not really matter what is currently selected, only what is marked and what is clicked. The anchor is not expected to be part of the existing selection, and does not move on programmatic selection either."
	#(#() #(3) #(1 2 3) #(3 4 5 6)) do: 
			[:oldSelections |
			presenter selectionsByIndex: oldSelections.
			self verifySelectionsFromMouseDown: event equals: #(3 4 5)].
	event := self mouseDownEventOnItem: 3 buttons: #(#left #shift).
	self verifySelectionsFromMouseDown: event equals: #(3)! !

!MultiSelectListViewTest categoriesForMethods!
initializePresenter!public!Running! !
marqueeSelectionEventsToItem:!helpers!private! !
sortSelections!private!unit tests! !
testEventsFromMarqueeSelectionChange!public!unit tests! !
testNewSelectionsCtrlShiftClickAdditive!public!unit tests! !
testNewSelectionsCtrlShiftClickSubtractive!public!unit tests! !
testNewSelectionsShiftClickWithSelectionMark!public!unit tests! !
!

