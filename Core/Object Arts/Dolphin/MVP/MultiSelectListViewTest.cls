"Filed out from Dolphin Smalltalk 7"!

ListViewTest subclass: #MultiSelectListViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MultiSelectListViewTest guid: (GUID fromString: '{67F073DF-D832-4F4F-A5C1-57D8730E3515}')!
MultiSelectListViewTest comment: ''!
!MultiSelectListViewTest categoriesForClass!Unclassified! !
!MultiSelectListViewTest methodsFor!

initializePresenter
	super initializePresenter.
	presenter view isMultiSelect: true!

sortSelections
	^#(49 50)!

testSelectionsByIndex
	| objects sel |
	objects := self objectsToTest.
	presenter view isMultiSelect: true.
	presenter model addAll: objects.
	"Select a single object"
	sel := Array with: objects size.
	self
		should: [presenter selectionsByIndex: sel]
		trigger: #selectionChanged
		against: presenter.
	self assert: sel equals: presenter selectionsByIndex.
	"Selecting same element should be a no-op"
	self
		shouldnt: [presenter selectionsByIndex: sel]
		trigger: #selectionChanged
		against: presenter.
	self assert: sel equals: presenter selectionsByIndex.
	"Selecting a pair including the existing selection"
	sel := Array with: 1 with: objects size.
	self
		should: [presenter selectionsByIndex: sel]
		trigger: #selectionChanged
		against: presenter.
	self assert: sel equals: presenter selectionsByIndex.
	"Selecting same pair should be a no-op"
	self
		shouldnt: [presenter selectionsByIndex: sel]
		trigger: #selectionChanged
		against: presenter.
	self assert: sel equals: presenter selectionsByIndex.
	"Selecting single item from existing selection should remove other selections"
	sel := #(1).
	self
		should: [presenter selectionsByIndex: sel]
		trigger: #selectionChanged
		against: presenter.
	self assert: sel equals: presenter selectionsByIndex.
	"Selecting a different pair not including the existing single selection"
	sel := Array with: 2 with: objects size - 1.
	self
		should: [presenter selectionsByIndex: sel]
		trigger: #selectionChanged
		against: presenter.
	self assert: sel equals: presenter selectionsByIndex.
	"#selectionByIndex: should also clear other selections"
	sel := sel copyFrom: 2.
	self
		should: [presenter selectionByIndex: sel first]
		trigger: #selectionChanged
		against: presenter.
	self assert: sel equals: presenter selectionsByIndex! !
!MultiSelectListViewTest categoriesFor: #initializePresenter!public!Running! !
!MultiSelectListViewTest categoriesFor: #sortSelections!private!unit tests! !
!MultiSelectListViewTest categoriesFor: #testSelectionsByIndex!public!unit tests! !

