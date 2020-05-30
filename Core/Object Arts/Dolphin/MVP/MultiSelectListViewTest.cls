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

testNewSelectionsCtrlShiftClickAdditive
	| event |
	self setUpForSelectionTesting.
	presenter
		selectionsByIndex: #(1 3);
		anchorIndex: 3.
	event := self mouseDownEventOnItem: 7 buttons: #(#left #control #shift).
	self verifyNewSelectionsFromEvent: event equals: #(1 3 4 5 6 7).
	presenter selectionsByIndex: #(1 3 5 7).
	"Programatically changing selection does not change the anchor."
	self assert: presenter anchorIndex equals: 3.
	self verifyNewSelectionsFromEvent: event equals: #(1 3 4 5 6 7)!

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
	self verifyNewSelectionsFromEvent: event equals: #(1 2 7).
	presenter selectionsByIndex: #(1 3 5 7).
	self verifyNewSelectionsFromEvent: event equals: #(1 2 7)!

testNewSelectionsShiftClickWithSelectionMark
	| event |
	self setUpForSelectionTesting.
	presenter anchorIndex: 3.
	event := self mouseDownEventOnItem: 5 buttons: #(#left #shift).
	"In a ListView it does not really matter what is currently selected, only what is marked and what is clicked. The anchor is not expected to be part of the existing selection, and does not move on programmatic selection either."
	#(#() #(3) #(1 2 3) #(3 4 5 6)) do: 
			[:oldSelections |
			presenter selectionsByIndex: oldSelections.
			self verifyNewSelectionsFromEvent: event equals: #(3 4 5)].
	event := self mouseDownEventOnItem: 3 buttons: #(#left #shift).
	self verifyNewSelectionsFromEvent: event equals: #(3)! !
!MultiSelectListViewTest categoriesFor: #initializePresenter!public!Running! !
!MultiSelectListViewTest categoriesFor: #sortSelections!private!unit tests! !
!MultiSelectListViewTest categoriesFor: #testNewSelectionsCtrlShiftClickAdditive!public!unit tests! !
!MultiSelectListViewTest categoriesFor: #testNewSelectionsCtrlShiftClickSubtractive!public!unit tests! !
!MultiSelectListViewTest categoriesFor: #testNewSelectionsShiftClickWithSelectionMark!public!unit tests! !

