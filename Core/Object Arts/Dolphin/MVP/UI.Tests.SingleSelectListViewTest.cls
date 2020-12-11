"Filed out from Dolphin Smalltalk 7"!

UI.Tests.ListViewTest subclass: #'UI.Tests.SingleSelectListViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ListViewConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.SingleSelectListViewTest guid: (Core.GUID fromString: '{176c59b9-4286-4753-8320-c9b5da469d9e}')!
UI.Tests.SingleSelectListViewTest comment: ''!
!UI.Tests.SingleSelectListViewTest categoriesForClass!Unclassified! !
!UI.Tests.SingleSelectListViewTest methodsFor!

sortSelections
	^#(50)!

testSelectionModeChange
	| objects caret |
	self deny: self isMultiSelect.
	objects := self objectsToTest.
	presenter model addAll: objects.
	presenter selectionByIndex: 1.
	self
		shouldnt: [presenter view isMultiSelect: true]
		trigger: #selectionChanged
		against: presenter.
	self assert: self isMultiSelect.
	self assert: presenter selectionsByIndex equals: #(1).
	presenter selectionsByIndex: #(2 3).
	caret := presenter view caretIndex.
	self assert: caret equals: 3.
	self
		should: [presenter view isMultiSelect: false]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selectionByIndex equals: caret.
	presenter view selectionsByIndex: #(1 2).
	self assert: presenter selectionsByIndex equals: #(1)! !
!UI.Tests.SingleSelectListViewTest categoriesFor: #sortSelections!private!unit tests! !
!UI.Tests.SingleSelectListViewTest categoriesFor: #testSelectionModeChange!public!unit tests! !

