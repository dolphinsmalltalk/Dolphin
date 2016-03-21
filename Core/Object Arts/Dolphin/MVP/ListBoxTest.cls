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

classToTest
	^ListBox!

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
!ListBoxTest categoriesFor: #classToTest!helpers!private! !
!ListBoxTest categoriesFor: #testLastSelectionCacheUpdatedOnRemove!public!unit tests! !
!ListBoxTest categoriesFor: #testSelectionModeChange!public!unit tests! !

