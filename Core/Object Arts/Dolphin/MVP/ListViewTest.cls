"Filed out from Dolphin Smalltalk 7"!

SelectableListItemsTest subclass: #ListViewTest
	instanceVariableNames: 'selectionChanging events selectionChanged nmClick clicks timedout'
	classVariableNames: ''
	poolDictionaries: 'ListViewConstants'
	classInstanceVariableNames: ''!
ListViewTest guid: (GUID fromString: '{bce10a8d-244e-4377-846c-bcbef9d853a1}')!
ListViewTest isAbstract: true!
ListViewTest comment: ''!
!ListViewTest categoriesForClass!Unclassified! !
!ListViewTest methodsFor!

assertCaretVisible
	| pos view |
	view := presenter view.
	pos := (view itemRect: view caretIndex) origin.
	self assert: (view rectangle containsPoint: pos)!

classToTest
	^ListView!

expectedSelectionsForSendShiftClickTests
	^self subclassResponsibility!

getColumns
	| answer |
	answer := OrderedCollection new.
	0 to: 256
		do: 
			[:each |
			| col |
			col := LVCOLUMNW new.
			col newTextBuffer: 256.
			(presenter view
				sendMessage: LVM_GETCOLUMNW
				wParam: each
				lpParam: col) asBoolean
				ifTrue: 
					[col text: col text trimNulls.
					answer add: col]
				ifFalse: [^answer]]!

getItem: anInteger
	| item |
	item := LVITEMW new
				iItem: anInteger - 1;
				image: 0;
				newTextBuffer: 128;
				yourself.
	presenter view lvmGetItem: item.
	^item!

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

onSelectionChanged
	selectionChanged value!

onSelectionChanging: aSelectionChangingEvent 
	selectionChanging value: aSelectionChangingEvent!

onTimerTick: wParam
	wParam = self timeoutId ifTrue: [
		timedout := true.
		presenter view killTimer: self timeoutId.
		presenter view postMessage: WM_MOUSEMOVE wParam: 0 lParam: 0]!

sendClickEvent: aMouseEvent
	| pos |
	self assert: (aMouseEvent isLButtonDown or: [aMouseEvent isRButtonDown]).
	"Note that the ListView appears to take hold of the message loop in its handler for WM_?BUTTONDOWN, so we post the up before sending the down.
	The reason this works is that the 'up' will wait in the queue, but the 'down' will be sent straight to the window proc of the list view. That window
	proc is of course the Dolphin wndproc, which will forward the message into the image, where it will eventually arrive in ListView>>onButtonPressed:
	When ListView>>onButtonPressed: calls for default window processing (i.e. calls the ListView's actual wnd proc), the LV handler will then consume
	the mouse up from the queue."
	pos := POINTL new.
	UserLibrary default getCursorPos: pos;
		setCursorPosX: 0 y: 0.
	SessionManager inputState pumpMessages.
	presenter view
		postMessage: aMouseEvent message
			wParam: aMouseEvent wParam
			lParam: aMouseEvent lParam;
		postMessage: aMouseEvent message + 1
			wParam: (aMouseEvent wParam maskClear: aMouseEvent buttonFlag)
			lParam: aMouseEvent lParam.
	timedout := false.
	presenter view setTimer: self timeoutId interval: 500.
	"Dispatch the posted messages to the control"
	SessionManager inputState pumpMessages.
	presenter view killTimer: self timeoutId.
	UserLibrary default setCursorPosX: pos x y: pos y.
	"If this fires, it means the control did not return from the call to its window proc to handle the button down event in ListView>>onButtonPressed:"
	self deny: timedout description: 'Control blocked in mouse down handler'!

sendEvent: aMouseEvent 
	^presenter view sendMessage: aMouseEvent message wParam: aMouseEvent wParam lParam: aMouseEvent lParam!

setColumns: cols
	| list |
	presenter view columnsList: cols.
	list := self getColumns.
	self assert: (list collect: [:each | each text]) asArray
		equals: (cols collect: [:each | each text]) asArray.
	self assert: presenter view columnOrder equals: (1 to: cols size).
	^list!

setUpForSelectionEventTesting
	| anonClass method |
	self setUpForSelectionTesting.
	anonClass := ListView newAnonymousSubclass.
	presenter view becomeA: anonClass.
	method := anonClass
				compile: 'nmClick: pNMHDR
		#placeholder value: pNMHDR.
		^super nmClick: pNMHDR'.
	self assert: (method literalAt: 1) equals: #placeholder.
	clicks := OrderedCollection new.
	nmClick := [:itemactivate | clicks addLast: itemactivate copy].
	method whileMutableDo: 
			[method literalAt: 1 put: [:pNMHDR | nmClick value: (NMITEMACTIVATE fromAddress: pNMHDR)]].
	events := OrderedCollection new.
	presenter
		when: #selectionChanging:
			send: #onSelectionChanging:
			to: self;
		when: #selectionChanged
			send: #onSelectionChanged
			to: self.
	selectionChanging := [:event | events addLast: event].
	"The ListView (and other selectable item views) should really be generating a #selectionChanged: event with a SelectionChangedEvent parameter, but at present they don't"
	selectionChanged := 
			[events addLast: ((SelectionChangedEvent forSource: presenter)
						newSelections: presenter view selectionsByIndex;
						yourself)].
	presenter when: #timerTick: send: #onTimerTick: to: self.
	timedout := false!

setUpForSelectionTesting
	presenter
		list: (1 to: 10);
		viewMode: #list!

sortSelections
	^self subclassResponsibility!

testBackImage
	| watermark |
	self deny: presenter view backImageIsTiled.
	self assert: presenter view backImageOffset equals: Point zero.
	self assert: presenter view backImageAlphaPercent equals: 100.
	self assert: presenter view backImage isNil.
	watermark := Bitmap fromFile: 'Resources\IdeaSpaceBackdrop.bmp'
				usingLocator: FileLocator installRelative.
	presenter view backImage:  watermark; backImageAlphaPercent: 60; backImageIsTiled: true.
	self assert: presenter view backImage identicalTo: watermark.
	self assert: presenter view backImageAlphaPercent equals: 60.
	self assert: presenter view backImageIsTiled
!

testChangeViewMode
	"#1510"

	| column |
	self assert: presenter isVirtual.
	presenter viewMode: #report.
	self assert: presenter viewMode identicalTo: #report.
	column := presenter primaryColumn.
	presenter getTextBlock: [:each | each first].
	column getTextBlock: [:each | each second].
	presenter model list: #(#('1' '2') #('11' '22')).
	2 timesRepeat: 
			[presenter model keysAndValuesDo: 
					[:i :each |
					| text |
					text := presenter getItemText: i.
					self assert: text equals: each second].
			presenter viewMode: #smallIcons.
			presenter model keysAndValuesDo: 
					[:i :each |
					| text |
					text := presenter getItemText: i.
					self assert: text equals: each first].
			presenter viewMode: #report.
			"Switch to non-virtual"
			presenter isVirtual: false.
			presenter refreshContents]!

testColumnsList
	"Remove the first column"

	| cols |
	cols := self getColumns.
	self assert: cols size equals: 1.
	self assert: cols first text equals: 'Column 1'.
	self assert: presenter view columnOrder equals: (1 to: 1).
	cols := (1 to: 6) collect: 
					[:each |
					(ListViewColumn text: each displayString)
						isAutoResize: true;
						yourself].
	self setColumns: cols.
	"Remove the first column"
	cols := cols copyFrom: 2.
	presenter view columnsList: cols.
	self setColumns: cols.

	"Remove the last column"
	cols := cols copyFrom: 1 to: 4.
	self setColumns: cols.

	"Remove last two columns"
	cols := cols copyFrom: 1 to: 2.
	self setColumns: cols.

	"Add one back on the end"
	cols := cols copyWith: ((ListViewColumn text: '4')
						isAutoResize: true;
						yourself).
	self setColumns: cols.

	"Add one on the front"
	cols := (OrderedCollection withAll: cols)
				addFirst: ((ListViewColumn text: '1')
							isAutoResize: true;
							yourself);
				yourself.
	self setColumns: cols.

	"Remove two from the middle."
	cols := cols copy
				removeAtIndex: 2;
				removeAtIndex: 2;
				yourself.
	self setColumns: cols.

	"Remove them all"
	self setColumns: #()!

testLastSelectionCacheUpdatedOnRemove
	"#717"

	| objects |
	objects := self objectsToTest.
	presenter model addAll: objects.
	self assert: presenter hasSelection not.
	presenter selection: objects second.
	self assert: (presenter instVarNamed: 'lastSelIndices') equals: #(2).
	presenter model removeAtIndex: 1.
	self assert: (presenter instVarNamed: 'lastSelIndices') equals: #(1)!

testNewSelectionsLeftClickOutsideList
	| event |
	self setUpForSelectionTesting.
	event := self mouseDownEventOnItem: 0 buttons: #(#left).
	self assert: (presenter newSelectionsFromEvent: event) equals: #().
	presenter selectionsByIndex: #(3).
	self assert: (presenter newSelectionsFromEvent: event) equals: #()!

testNewSelectionsSimpleLeftClick
	| event |
	self setUpForSelectionTesting.
	event := self mouseDownEventOnItem: 1 buttons: #(#left).
	self assert: (presenter newSelectionsFromEvent: event) equals: #(1).
	presenter selectionsByIndex: #(3).
	self assert: (presenter newSelectionsFromEvent: event) equals: #(1)!

testNilRow
	"#2157"

	| m c item txt |
	presenter viewMode: #report.
	m := ListModel on: #(nil) , (1 to: 5).
	presenter model: m.
	c := presenter view columnAtIndex: 1.
	txt := 'this is nil'.
	c getTextBlock: [:it | it ifNil: [txt]].
	item := self getItem: 1.
	self assert: item pszText equals: txt.
	self assert: item iImage equals: nil icon imageIndex - 1!

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

testSelectionEventsFromLeftClick
	"Test that the expected sequence of selectionChanging: and selectionChanged events are raised for left-click selection.
	The test sends simulated mouse clicks to the control to try and test the actual control integration."

	self setUpForSelectionEventTesting.
	self verifyEventsFromClickConfirmed: #left!

testSelectionEventsFromLeftClickDenied
	"Test that the expected sequence of selection events are raised for left-click selection when the selectionChanging: event is denied
	but without a prompt so the control still receives the mouse up."

	self setUpForSelectionEventTesting.
	selectionChanging := 
			[:selChanging |
			events addLast: selChanging.
			selChanging value: false].
	self verifyEventsFromClickDenied: #left!

testSelectionEventsFromLeftClickPromptConfirmed
	"Test that the expected sequence of selection events are raised for left-click selection when the selectionChanging: event is confirmed with a prompt so the control does not receive the mouse up associated with the actual click.
	Regression test for #898."

	"Test fails because the listview blocks in a modal message loop in its WM_LBUTTONDOWN handler"
	self skipIfCiBuild.
	self setUpForSelectionEventTesting.
	selectionChanging := 
			[:selChanging |
			| msg |
			events addLast: selChanging.
			"Consume the mouse up so the control does not receive it."
			msg := MSG new.
			UserLibrary default
				getMessage: msg
				hWnd: presenter view handle
				wMsgFilterMin: WM_LBUTTONUP
				wMsgFilterMax: WM_LBUTTONUP.
			"Allow the selection change to proceed"
			selChanging value: true].
	self verifyEventsFromClickConfirmed: #left!

testSelectionEventsFromLeftClickPromptDenied
	"Test that the expected sequence of selection events are raised for left-click selection when the selectionChanging: event is denied with a prompt so the control does not receive the mouse up associated with the actual click."

	self setUpForSelectionEventTesting.
	selectionChanging := 
			[:selChanging |
			| msg |
			events addLast: selChanging.
			"Snaffle the mouse up to try and simulate the appearance of a prompt"
			msg := MSG new.
			UserLibrary default
				getMessage: msg
				hWnd: presenter view handle
				wMsgFilterMin: WM_LBUTTONUP
				wMsgFilterMax: WM_LBUTTONUP.
			"Prevent the selection change from proceeding"
			selChanging value: false].
	self verifyEventsFromClickDenied: #left!

testSelectionRemainsVisibleOnSort
	"#1381"

	| view |
	view := presenter view.
	view list: (0 to: 100) asOrderedCollection.
	view selections: self sortSelections.
	self assertCaretVisible.
	view columnClicked: 1.
	self assertCaretVisible.
	view columnClicked: 1.
	self assertCaretVisible!

testSetTextBlockDoesNotAffectSelection
	2 timesRepeat: 
			[super testSetTextBlockDoesNotAffectSelection.
			presenter view isVirtual: false]!

testSetTextImageDoesNotAffectSelection
	| objects |
	objects := self objectsToTest.
	presenter view isVirtual: false.
	0 to: 1
		do: 
			[:i |
			presenter model removeAll.
			presenter view isVirtual: i asBoolean.
			presenter model addAll: objects.
			presenter selectionByIndex: 2.
			self
				shouldnt: 
					["Remove an object after the selection"
					presenter view getImageBlock: [:each | each icon imageIndex + 1]]
				trigger: #selectionChanged
				against: presenter.
			self assert: presenter selectionByIndex identicalTo: 2.
			self
				shouldnt: [presenter selectionByIndex: 2]
				trigger: #selectionChanging:
				against: presenter]!

timeoutId
	^171717!

verifyEventsFromClickConfirmed: aSymbol
	| changed changing click event |
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
	self assert: clicks size equals: 1.
	click := clicks first.
	self assert: click iItem equals: 2 - 1.
	self assert: click position equals: event lParamX @ event lParamY.
	"Send a shift-left-click event over a subsequent item."
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
	self assert: clicks size equals: 1.
	self assert: clicks size equals: 1.
	click := clicks first.
	self assert: click iItem equals: 4 - 1.
	self assert: click position equals: event lParamX @ event lParamY!

verifyEventsFromClickDenied: aSymbol
	| event changing |
	event := self mouseDownEventOnItem: 2 buttons: {aSymbol}.
	self sendClickEvent: event.
	self assert: events size equals: 1.
	changing := events first.
	self assert: changing isKindOf: SelectionChangingEvent.
	self assert: changing oldSelections equals: #().
	self assert: changing newSelections equals: #(2).
	"Because we didn't forward the button down event to the control, there should be no click notification."
	self assert: clicks size equals: 0.
	"Ensure there is a selection and then send a shift-left-click event over a subsequent item."
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
	self assert: clicks size equals: 0! !
!ListViewTest categoriesFor: #assertCaretVisible!helpers!private! !
!ListViewTest categoriesFor: #classToTest!helpers!private! !
!ListViewTest categoriesFor: #expectedSelectionsForSendShiftClickTests!constants!private! !
!ListViewTest categoriesFor: #getColumns!helpers!private! !
!ListViewTest categoriesFor: #getItem:!helpers!private! !
!ListViewTest categoriesFor: #mouseDownEventOnItem:buttons:!helpers!private! !
!ListViewTest categoriesFor: #onSelectionChanged!helpers!private! !
!ListViewTest categoriesFor: #onSelectionChanging:!helpers!private! !
!ListViewTest categoriesFor: #onTimerTick:!helpers!private! !
!ListViewTest categoriesFor: #sendClickEvent:!helpers!private! !
!ListViewTest categoriesFor: #sendEvent:!helpers!private! !
!ListViewTest categoriesFor: #setColumns:!helpers!private! !
!ListViewTest categoriesFor: #setUpForSelectionEventTesting!helpers!private! !
!ListViewTest categoriesFor: #setUpForSelectionTesting!helpers!private! !
!ListViewTest categoriesFor: #sortSelections!helpers!public! !
!ListViewTest categoriesFor: #testBackImage!public!unit tests! !
!ListViewTest categoriesFor: #testChangeViewMode!public!unit tests! !
!ListViewTest categoriesFor: #testColumnsList!public!unit tests! !
!ListViewTest categoriesFor: #testLastSelectionCacheUpdatedOnRemove!public!unit tests! !
!ListViewTest categoriesFor: #testNewSelectionsLeftClickOutsideList!public!unit tests! !
!ListViewTest categoriesFor: #testNewSelectionsSimpleLeftClick!public!unit tests! !
!ListViewTest categoriesFor: #testNilRow!public!unit tests! !
!ListViewTest categoriesFor: #testProgrammaticSelectionVisible!public!unit tests! !
!ListViewTest categoriesFor: #testSelectionEventsFromLeftClick!public!unit tests! !
!ListViewTest categoriesFor: #testSelectionEventsFromLeftClickDenied!public!unit tests! !
!ListViewTest categoriesFor: #testSelectionEventsFromLeftClickPromptConfirmed!public!unit tests! !
!ListViewTest categoriesFor: #testSelectionEventsFromLeftClickPromptDenied!public!unit tests! !
!ListViewTest categoriesFor: #testSelectionRemainsVisibleOnSort!public!unit tests! !
!ListViewTest categoriesFor: #testSetTextBlockDoesNotAffectSelection!public!unit tests! !
!ListViewTest categoriesFor: #testSetTextImageDoesNotAffectSelection!public!unit tests! !
!ListViewTest categoriesFor: #timeoutId!constants!private! !
!ListViewTest categoriesFor: #verifyEventsFromClickConfirmed:!helpers!private! !
!ListViewTest categoriesFor: #verifyEventsFromClickDenied:!helpers!private! !

