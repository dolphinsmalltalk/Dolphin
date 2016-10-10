"Filed out from Dolphin Smalltalk 7"!

SelectableListItemsTest subclass: #ListBoxTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ListBoxTest guid: (GUID fromString: '{8E5A59A5-F500-4D07-9EA2-B1019C9302B2}')!
ListBoxTest comment: ''!
!ListBoxTest categoriesForClass!Unclassified! !
!ListBoxTest methodsFor!

testLastSelectionCacheUpdatedOnRemove
	"#717"
	| objects |
	objects := self objectsToTest.
	presenter model addAll: objects.
	self assert: presenter hasSelection not.
	presenter selection: objects second.
	self assert: (presenter instVarNamed: 'lastSelIndices') = #(2).
	presenter model removeAtIndex: 1.
	self assert: (presenter instVarNamed: 'lastSelIndices') = #(1)!

testLastSelectionCacheUpdatedOnRemoveMulti
	presenter view isMultiSelect: true.
	self testLastSelectionCacheUpdatedOnRemove.
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

testSelectionModeChange
	| objects |
	self deny: presenter view isMultiSelect.
	objects := self objectsToTest.
	presenter model addAll: objects.
	self assert: presenter hasSelection not.
	self assert: presenter selectionOrNil isNil.
	"Must trigger a selection change when switching to multi-select, as otherwise observers do not know the mode change has occurred."
	self 
		should: [presenter view isMultiSelect: true]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter hasSelection not.
	self assert: presenter selectionOrNil isNil.
	self assert: presenter view selectionMode == #multi.
	self 
		shouldnt: [presenter view selectionMode: #toggle]
		trigger: #selectionChanged
		against: presenter.
	self 
		shouldnt: [presenter view selectionMode: #multi]
		trigger: #selectionChanged
		against: presenter.
	self 
		should: [presenter view isMultiSelect: false]
		trigger: #selectionChanged
		against: presenter.
	presenter selection: objects second.
	self assert: presenter view selectionsByIndex = #(2).
	self should: [presenter view getMultipleSelections] raise: Error.
	self 
		should: [presenter view isMultiSelect: true]
		trigger: #selectionChanged
		against: presenter.
	"#115: Changing list box selection mode fails if there are selections"
	self assert: presenter view selectionsByIndex = #(2)! !
!ListBoxTest categoriesFor: #testLastSelectionCacheUpdatedOnRemove!public!unit tests! !
!ListBoxTest categoriesFor: #testLastSelectionCacheUpdatedOnRemoveMulti!public!unit tests! !
!ListBoxTest categoriesFor: #testSelectionModeChange!public!unit tests! !

!ListBoxTest class methodsFor!

classToTest
	^ListBox! !
!ListBoxTest class categoriesFor: #classToTest!helpers!private! !

