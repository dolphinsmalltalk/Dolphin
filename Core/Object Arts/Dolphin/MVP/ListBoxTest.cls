"Filed out from Dolphin Smalltalk 7"!

ListControlTest subclass: #ListBoxTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ListBoxTest guid: (GUID fromString: '{0cceab03-640d-4bd6-8e8c-1da96bf288d2}')!
ListBoxTest isAbstract: true!
ListBoxTest comment: ''!
!ListBoxTest categoriesForClass!Unclassified! !
!ListBoxTest methodsFor!

classToTest
	^ListBox!

newSelectionAfterLeftClickOutsideList: anArrayOfInteger 
	^anArrayOfInteger!

sendClickEvent: aMouseEvent
	| keyState newKeyState |
	"The ListBox control ignores the button/key state flags the mouse messages and uses the keyboard state, so unfortunately we have to set that.
	We use an ensure: block to prevent keys appearing stuck down if there is an error, but stopping in the debugger after the key state is set, but before the ensure block is run, will leave the shift and/or control keys stuck down. Hitting the actual keys will clear this though."
	keyState := Keyboard default getState.
	newKeyState := keyState copy.
	aMouseEvent isCtrlDown ifTrue: [newKeyState at: VK_CONTROL + 1 put: 128].
	aMouseEvent isShiftDown ifTrue: [newKeyState at: VK_SHIFT + 1 put: 128].
	self postClickEvent: aMouseEvent.
	
	[newKeyState = keyState ifFalse: [UserLibrary default setKeyboardState: newKeyState].
	"Dispatch the posted messages to the control"
	SessionManager inputState pumpMessages]
			ensure: [newKeyState = keyState ifFalse: [UserLibrary default setKeyboardState: keyState]]!

testNewSelectionsClickOutsideListWithModifiers
	| event selection expected |
	self setUpForSelectionTesting.
	selection := #(1).
	"Behaviour of the ListBox in multi-select mode differs from the ListView in that clicking past the end is the same as clicking at the end."
	OrderedCollection new
		add: #(#(#control) #(1 10));
		add: {#(#shift). 1 to: 10};
		add: {#(#control #shift). 1 to: 10};
		do: 
				[:pair |
				presenter selectionsByIndex: selection.
				event := self mouseDownEventOnItem: 0 buttons: (pair first copyWith: #left).
				expected := self isMultiSelect ifTrue: [pair second] ifFalse: [selection].
				self verifyNewSelectionsFromEvent: event equals: expected]! !
!ListBoxTest categoriesFor: #classToTest!helpers!private! !
!ListBoxTest categoriesFor: #newSelectionAfterLeftClickOutsideList:!helpers!private! !
!ListBoxTest categoriesFor: #sendClickEvent:!helpers!private! !
!ListBoxTest categoriesFor: #testNewSelectionsClickOutsideListWithModifiers!public!unit tests! !

