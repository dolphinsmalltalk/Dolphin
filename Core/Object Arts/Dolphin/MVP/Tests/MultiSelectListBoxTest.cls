"Filed out from Dolphin Smalltalk"!

ListBoxTest subclass: #MultiSelectListBoxTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MultiSelectListBoxTest guid: (GUID fromString: '{fb3d047d-54ac-4e72-8544-a555167d6af9}')!

MultiSelectListBoxTest comment: 'Test a ListBox in multi-select mode. Inherited tests will exercise the single-selection protocols. As of D6 these should behave for a multi-select list in teh same way as they do for a single-select list.'!

!MultiSelectListBoxTest categoriesForClass!Unclassified! !

!MultiSelectListBoxTest methodsFor!

initializePresenter
	super initializePresenter.
	presenter view isMultiSelect: true!

testNewSelectionsCtrlShiftClickAdditive
	| event |
	self setUpForSelectionTesting.
	presenter
		selectionsByIndex: #(1 3);
		anchorIndex: 3.
	event := self mouseDownEventOnItem: 7 buttons: #(#left #control #shift).
	self verifySelectionsFromMouseDown: event equals: #(1 3 4 5 6 7).
	presenter selectionsByIndex: #(1 3 5 7).
	"Programatically changing selection in a ListBox does change the anchor (because it expects that the anchor is part of the selection, unsually the last selected item), unlike a ListView."
	self assert: presenter anchorIndex equals: 7.
	presenter anchorIndex: 3.
	self verifySelectionsFromMouseDown: event equals: #(1 3 4 5 6 7)!

testNewSelectionsCtrlShiftClickSubtractive
	| event |
	self setUpForSelectionTesting.
	presenter
		selectionsByIndex: #(1 2 3 4 5 7);
		anchorIndex: 6.
	event := self mouseDownEventOnItem: 2 buttons: #(#left #control #shift).
	"ListBox does not seem to have the issue that we have with ListView where the ctrl-shift-left-clicked item is retained in the selection when it should not be"
	self verifySelectionsFromMouseDown: event equals: #(1 7).
	self assert: presenter caretIndex equals: 2.
	presenter selectionsByIndex: #(1 3 5 7).
	"Unlike ListView, programmatically changing the selection moves the anchor, so we must reset it."
	presenter anchorIndex: 6.
	self verifySelectionsFromMouseDown: event equals: #(1 7)!

testNewSelectionsShiftClickWithSelectionMark
	| event |
	self setUpForSelectionTesting.
	event := self mouseDownEventOnItem: 5 buttons: #(#left #shift).
	#(#() #(3) #(1 2 3) #(3 4 5 6)) do: 
			[:oldSelections |
			| expected |
			presenter selectionsByIndex: oldSelections.
			"Changing the selections in a ListBox moves the anchor (because it expects that the anchor is effectively the last selected item), so we must reset it each time."
			presenter anchorIndex: 3.
			self assert: presenter anchorIndex equals: 3.
			"In a ListBox, unlike a ListView, the current selection does matter. If the anchor is set to an item in the selection, then that item will still be selected on a Shift-Click. If the anchor is not a selected item, then the selection will on Shift-Click will not include it."
			expected := (oldSelections includes: 3) ifTrue: [#(3 4 5)] ifFalse: [#(4 5)].
			self verifySelectionsFromMouseDown: event equals: expected].
	event := self mouseDownEventOnItem: 3 buttons: #(#left #shift).
	self verifySelectionsFromMouseDown: event equals: #(3)!

testNewSelectionsToggleMode
	| event |
	self setUpForSelectionTesting.
	presenter selectionMode: #toggle.
	event := self mouseDownEventOnItem: 5 buttons: #(#left).
	"Toggle on, no selection"
	self verifySelectionsFromMouseDown: event equals: #(5).
	"Toggle on, existing selection"
	self verifySelectionsFromMouseDown: (self mouseDownEventOnItem: 3 buttons: #(#left)) equals: #(3 5).
	"Right click on existing selection, no change."
	self verifySelectionsFromMouseDown: (self mouseDownEventOnItem: 3 buttons: #(#right)) equals: #(3 5).
	"Right click on new selection, adds to selection..."
	self verifySelectionsFromMouseDown: (self mouseDownEventOnItem: 1 buttons: #(#right))
		equals: #(1 3 5).
	"... but not with modifiers"
	#(#(#control #right) #(#shift #right) #(#control #shift #right))
		do: [:each | self verifySelectionsFromMouseDown: (self mouseDownEventOnItem: 2 buttons: each) equals: #(1 3 5)].
	self assert: presenter caretIndex equals: 5.
	"Click past end same as clicking on last selected"
	self verifySelectionsFromMouseDown: (self mouseDownEventOnItem: 0 buttons: #(#left)) equals: #(1 3).
	"The control has an odd behaviour that clicking past the end moves the caret that it reports to the last item, but internally it remembers a separate focused item and toggles that.
	This seems like a bug, but means that we can't correctly determine the effect of clicks past the end in a toggle mode multi-select list box. It looks like this will require tracking the last selected item"
	false
		ifTrue: 
			[self verifySelectionsFromMouseDown: (self mouseDownEventOnItem: 0 buttons: #(#left))
				equals: #(1 3 5)].
	"Toggle off with left click"
	self verifySelectionsFromMouseDown: event equals: #(1 3 5).
	"Modifiers disable right clicks"
	#(#(#control #right) #(#shift #right) #(#control #shift #right))
		do: [:each | self verifySelectionsFromMouseDown: (self mouseDownEventOnItem: 7 buttons: each) equals: #(1 3 5)]! !

!MultiSelectListBoxTest categoriesForMethods!
initializePresenter!private!Running! !
testNewSelectionsCtrlShiftClickAdditive!public!unit tests! !
testNewSelectionsCtrlShiftClickSubtractive!public!unit tests! !
testNewSelectionsShiftClickWithSelectionMark!public!unit tests! !
testNewSelectionsToggleMode!public!unit tests! !
!

