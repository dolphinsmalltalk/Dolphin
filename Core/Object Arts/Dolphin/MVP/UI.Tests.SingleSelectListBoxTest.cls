"Filed out from Dolphin Smalltalk 7"!

ListBoxTest subclass: #SingleSelectListBoxTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SingleSelectListBoxTest guid: (GUID fromString: '{8e5a59a5-f500-4d07-9ea2-b1019c9302b2}')!
SingleSelectListBoxTest comment: ''!
!SingleSelectListBoxTest categoriesForClass!Unclassified! !
!SingleSelectListBoxTest methodsFor!

testSelectionModeChange
	| objects |
	self deny: self isMultiSelect.
	objects := self objectsToTest.
	presenter model addAll: objects.
	self assert: presenter hasSelection not.
	self assertIsNil: presenter selectionOrNil.
	"Must trigger a selection change when switching to multi-select, as otherwise observers do not know the mode change has occurred."
	self
		should: [presenter view isMultiSelect: true]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter hasSelection not.
	self assertIsNil: presenter selectionOrNil.
	self assert: presenter view selectionMode identicalTo: #multi.
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
	self assert: presenter view selectionsByIndex equals: #(2).
	self should: [presenter view getMultipleSelections] raise: Error.
	self
		should: [presenter view isMultiSelect: true]
		trigger: #selectionChanged
		against: presenter.
	"#115: Changing list box selection mode fails if there are selections"
	self assert: presenter view selectionsByIndex equals: #(2)! !
!SingleSelectListBoxTest categoriesFor: #testSelectionModeChange!public!unit tests! !

!SingleSelectListBoxTest class methodsFor!

classToTest
	^ListPresenter! !
!SingleSelectListBoxTest class categoriesFor: #classToTest!helpers!private! !

