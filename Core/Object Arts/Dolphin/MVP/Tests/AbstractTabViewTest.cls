"Filed out from Dolphin Smalltalk"!

SelectableListItemsTest subclass: #AbstractTabViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AbstractTabViewTest guid: (GUID fromString: '{e34db17b-bb62-4e11-a528-f70a21fe9d81}')!

AbstractTabViewTest isAbstract: true!

AbstractTabViewTest comment: ''!

!AbstractTabViewTest categoriesForClass!Unclassified! !

!AbstractTabViewTest methodsFor!

addTestTabs
	presenter model
		removeAll;
		addAll: self objectsToTest!

autoSelectsFirst
	^true!

initializePresenter
	super initializePresenter.
	presenter parentView designExtent: 500 @ 100.
	presenter viewMode: #smallIcons.
	"For the non-inherited tests, add some example tabs"
	((self class lookupMethod: self selector) methodClass includesBehavior: AbstractTabViewTest)
		ifTrue: [self addTestTabs]!

removingResetsSelection
	^false!

testSelectionChangeDenied
	| mouseClick event |
	presenter selectionByIndex: 1.
	self observeSelectionEvents.
	selectionChanging := 
			[:selectionChange |
			self assert: selectionChange oldSelections equals: {self objectsToTest first}.
			events add: selectionChange.
			selectionChange value: false].
	mouseClick := self mouseDownEventOnItem: 2 buttons: { #left }.
	self sendClickEvent: mouseClick.
	self assert: presenter selectionsByIndex equals: #(1).
	event := events single.
	self assert: event isKindOf: SelectionChangingEvent!

testSelectionsPreservedOnRecreate
	presenter selectionByIndex: 2.
	presenter recreate.
	self assert: presenter selectionsByIndex equals: #(2)!

testSetTextImageDoesNotAffectSelection
	presenter selectionByIndex: 2.
	self
		shouldnt: [presenter view getImageBlock: [:each | each icon imageIndex + 1]]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selectionByIndex identicalTo: 2.
	self
		shouldnt: [presenter selectionByIndex: 2]
		trigger: #selectionChanging:
		against: presenter!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	self assertIsNil: view customDrawBlock.
	self assert: view largeIconExtent equals: Icon largeExtent.
	self assert: view viewMode identicalTo: #noIcons! !

!AbstractTabViewTest categoriesForMethods!
addTestTabs!helpers!private! !
autoSelectsFirst!private!testing! !
initializePresenter!initializing!public! !
removingResetsSelection!private!testing! !
testSelectionChangeDenied!public!testing! !
testSelectionsPreservedOnRecreate!public!unit tests! !
testSetTextImageDoesNotAffectSelection!public!unit tests! !
verifyUpgradedView:identifier:!helpers!private! !
!

