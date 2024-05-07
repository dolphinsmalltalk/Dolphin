"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #SelectableItemsTest
	instanceVariableNames: 'events selectionChanging selectionChanged timedout'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SelectableItemsTest guid: (GUID fromString: '{eb11681e-441a-44d4-af4c-de1ea399a79e}')!

SelectableItemsTest isAbstract: true!

SelectableItemsTest comment: ''!

!SelectableItemsTest categoriesForClass!Unclassified! !

!SelectableItemsTest methodsFor!

assertContains: anObject
	"Private - Asserts that the receiver contains anObject. We do this by trying to select the object since this allows
	us to verify whether the view is actually displaying the object in addition to it just appearing in the model"

	| sel |
	sel := presenter selectionOrNil.
	presenter selection: anObject.
	self assert: presenter selection identicalTo: anObject.
	presenter selectionOrNil: sel!

defaultSelectionChangedAction
	^
	[events addLast: ((SelectionChangedEvent forSource: presenter)
				newSelections: presenter view selectionsByIndex;
				yourself)]!

denyContains: anObject 
	"Private - Asserts that the receiver does not contain anObject. We do this by trying to select the object since this allows
	us to verify whether the view is actually displaying the object in addition to it jsut appearing in the model"

	| sel |
	sel := presenter selectionOrNil.
	[self should: [presenter selection: anObject] raise: NotFoundError] 
		ensure: [presenter selectionOrNil: sel]!

mouseDownEventAt: position buttons: anArray
	| mouseButton keys |
	mouseButton := anArray intersection: #(#left #right #middle).
	self assert: mouseButton size equals: 1.
	mouseButton := mouseButton anyOne.
	keys := (anArray collect: [:each | MouseEvent wParamFlags at: each]) fold: [:a :b | a bitOr: b].
	^MouseEvent
		window: self selectionView
		message: (##(IdentityDictionary
				withAll: {#left -> WM_LBUTTONDOWN. #right -> WM_RBUTTONDOWN. #middle -> WM_MBUTTONDOWN})
					at: mouseButton)
		wParam: keys
		lParam: position asDword!

mouseDownEventOn: anObject buttons: anArray
	^self mouseDownEventOnItem: (self selectionView handleFromObject: anObject) buttons: anArray!

mouseDownEventOnItem: itemHandle buttons: anArray
	| position |
	position := itemHandle isNull
				ifTrue: [self selectionView clientRectangle corner - 1]
				ifFalse: [(self selectionView itemRect: itemHandle) origin + 1].
	^self mouseDownEventAt: position buttons: anArray!

mouseUpForMouseDown: aMouseEvent
	| upEvent |
	upEvent := MouseEvent
				window: presenter
				message: aMouseEvent message + 1
				wParam: (aMouseEvent wParam maskClear: aMouseEvent buttonFlag)
				lParam: aMouseEvent lParam.
	^upEvent!

observeSelectionEvents
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
	selectionChanged := self defaultSelectionChangedAction!

onSelectionChanged
	selectionChanged value!

onSelectionChanging: aSelectionChangingEvent 
	selectionChanging value: aSelectionChangingEvent!

onTimerTick: wParam
	(wParam == WM_LBUTTONDOWN or: [wParam == WM_RBUTTONDOWN])
		ifTrue: 
			[timedout := true.
			presenter killTimer: wParam.
			"Post a mouse up so that the ListView control returns from its WM_?BUTTONDOWN handler"
			presenter postMessage: wParam + 1 wParam: 0 lParam: 0]!

postMouseEvents: aSequencedReadableCollection
	| view |
	self assert: aSequencedReadableCollection first isButtonDown.
	"Clear the message queue"
	SessionManager inputState pumpMessages.
	view := self selectionView.
	aSequencedReadableCollection do: 
			[:each |
			view
				postMessage: each message
				wParam: each wParam
				lParam: each lParam]!

selectionView
	^presenter view!

sendClickEvent: aMouseEvent
	| pos |
	"The mouse needs to be outside any Dolphin window in order to cause the control's WM_?BUTTONDOWN handler to block in the way described in #898"
	pos := POINTL newBuffer.
	UserLibrary default
		getCursorPos: pos;
		setCursorPosX: 0 y: 0.
	self sendMouseEvents: {aMouseEvent. self mouseUpForMouseDown: aMouseEvent}.
	UserLibrary default setCursorPosX: pos x y: pos y!

sendMouseEvents: aSequencedReadableCollection
	| keyState newKeyState aMouseEvent |
	"The ListBox control ignores the button/key state flags the mouse messages and uses the keyboard state, so unfortunately we have to set that.
	We use an ensure: block to prevent keys appearing stuck down if there is an error, but stopping in the debugger after the key state is set, but before the ensure block is run, will leave the shift and/or control keys stuck down. Hitting the actual keys will clear this though."
	keyState := Keyboard default getState.
	newKeyState := keyState copy.
	aMouseEvent := aSequencedReadableCollection first.
	aMouseEvent isCtrlDown ifTrue: [newKeyState at: VK_CONTROL + 1 put: 128].
	aMouseEvent isShiftDown ifTrue: [newKeyState at: VK_SHIFT + 1 put: 128].
	self postMouseEvents: aSequencedReadableCollection.

	"Schedule a WM_TIMER so that we can detect the control's WM_?BUTTONDOWN handler not returning"
	timedout := false.
	presenter view setTimer: aMouseEvent message interval: 500.
	"Dispatch the posted mouse down/up messages to the control"
	
	[newKeyState = keyState ifFalse: [UserLibrary default setKeyboardState: newKeyState].
	"Dispatch the posted messages to the control"
	false
		ifTrue: 
			[| i |
			i := aSequencedReadableCollection size.
			SessionManager inputState loopWhile: 
					[Sound bell.
					(i := i - 1) > 0]]
		ifFalse: [SessionManager inputState pumpMessages]]
			ensure: [newKeyState = keyState ifFalse: [UserLibrary default setKeyboardState: keyState]].
	presenter view killTimer: aMouseEvent message.
	"If this fires, it means the control did not return from the call to its window proc to handle the button down event in ListView>>onButtonPressed:"
	self deny: timedout description: 'Control blocked in mouse down handler'!

setupClickTimeout
	presenter view
		when: #timerTick:
		send: #onTimerTick:
		to: self.
	timedout := false! !

!SelectableItemsTest categoriesForMethods!
assertContains:!helpers!private! !
defaultSelectionChangedAction!helpers!private! !
denyContains:!helpers!private! !
mouseDownEventAt:buttons:!helpers!private! !
mouseDownEventOn:buttons:!helpers!private! !
mouseDownEventOnItem:buttons:!helpers!private! !
mouseUpForMouseDown:!helpers!private! !
observeSelectionEvents!helpers!private! !
onSelectionChanged!helpers!private! !
onSelectionChanging:!helpers!private! !
onTimerTick:!helpers!private! !
postMouseEvents:!helpers!private! !
selectionView!helpers!private! !
sendClickEvent:!helpers!private! !
sendMouseEvents:!helpers!private! !
setupClickTimeout!helpers!private! !
!

