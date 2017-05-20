"Filed out from Dolphin Smalltalk 7"!

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
	presenter view selectionMode: #multi!

testLastSelectionCacheUpdatedOnRemove
	super testLastSelectionCacheUpdatedOnRemove.
	presenter selectionsByIndex: #(2 4).
	self assert: (presenter instVarNamed: 'lastSelIndices') = #(2 4).
	self
		shouldnt: 
			[presenter model removeAll: (Array with: presenter model first with: (presenter model at: 3))]
		triggerAnyOf: #(#selectionChanging: #selectionChanged)
		against: presenter.
	self assert: (presenter instVarNamed: 'lastSelIndices') = #(1 2).
	self
		should: [presenter model removeAll: presenter model copy]
		trigger: #selectionChanged
		against: presenter.
	self assert: (presenter instVarNamed: 'lastSelIndices') = #().
	presenter model addAll: self objectsToTest.
	presenter selectionsByIndex: #(1 3 5).
	self assert: (presenter instVarNamed: 'lastSelIndices') = #(1 3 5).
	self
		should: [presenter model remove: presenter model last]
		trigger: #selectionChanged
		against: presenter.
	self assert: (presenter instVarNamed: 'lastSelIndices') = #(1 3)!

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
!MultiSelectListBoxTest categoriesFor: #initializePresenter!public!Running! !
!MultiSelectListBoxTest categoriesFor: #testLastSelectionCacheUpdatedOnRemove!public!unit tests! !
!MultiSelectListBoxTest categoriesFor: #testSelectionsByIndex!public!unit tests! !

