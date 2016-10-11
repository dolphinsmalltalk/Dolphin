"Filed out from Dolphin Smalltalk 7"!

ListViewTest subclass: #SingleSelectListViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ListViewConstants'
	classInstanceVariableNames: ''!
SingleSelectListViewTest guid: (GUID fromString: '{176C59B9-4286-4753-8320-C9B5DA469D9E}')!
SingleSelectListViewTest comment: ''!
!SingleSelectListViewTest categoriesForClass!Unclassified! !
!SingleSelectListViewTest methodsFor!

sortSelections
	^#(50)!

testSelectionModeChange
	| objects caret |
	self deny: presenter view isMultiSelect.
	objects := self objectsToTest.
	presenter model addAll: objects.
	presenter selectionByIndex: 1.
	self
		shouldnt: [presenter view isMultiSelect: true]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter view isMultiSelect.
	self assert: #(1) equals: presenter selectionsByIndex.
	presenter selectionsByIndex: #(2 3).
	caret := presenter view caretIndex.
	self assert: 3 equals: caret.
	self
		should: [presenter view isMultiSelect: false]
		trigger: #selectionChanged
		against: presenter.
	self assert: caret equals: presenter selectionByIndex.
	presenter view selectionsByIndex: #(1 2).
	self assert: #(1) equals: presenter selectionsByIndex! !
!SingleSelectListViewTest categoriesFor: #sortSelections!private!unit tests! !
!SingleSelectListViewTest categoriesFor: #testSelectionModeChange!public!unit tests! !

