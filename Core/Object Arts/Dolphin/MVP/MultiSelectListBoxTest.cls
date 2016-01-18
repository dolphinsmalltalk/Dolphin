"Filed out from Dolphin Smalltalk 7"!

ListBoxTest subclass: #MultiSelectListBoxTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MultiSelectListBoxTest guid: (GUID fromString: '{FB3D047D-54AC-4E72-8544-A555167D6AF9}')!
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
	self assert: (presenter instVarNamed: 'lastSelIndices') = #(1 3).
	!

testSelectionModeChange
	self assert: presenter view isMultiSelect! !
!MultiSelectListBoxTest categoriesFor: #initializePresenter!public!Running! !
!MultiSelectListBoxTest categoriesFor: #testLastSelectionCacheUpdatedOnRemove!public!unit tests! !
!MultiSelectListBoxTest categoriesFor: #testSelectionModeChange!public!unit tests! !

