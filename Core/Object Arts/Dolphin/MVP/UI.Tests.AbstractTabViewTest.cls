"Filed out from Dolphin Smalltalk"!

UI.Tests.SelectableListItemsTest
	subclass: #'UI.Tests.AbstractTabViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.AbstractTabViewTest guid: (Core.GUID fromString: '{484556c3-594e-4a29-853a-d890370527bc}')!
UI.Tests.AbstractTabViewTest isNonInstantiable: true!
UI.Tests.AbstractTabViewTest comment: ''!
!UI.Tests.AbstractTabViewTest methodsFor!

addTestTabs
	| objects |
	objects := self objectsToTest.
	presenter parentView extent: 500 @ 100.
	presenter viewMode: #smallIcons.
	presenter model
		removeAll;
		addAll: objects!

autoSelectsFirst
	^true!

removingResetsSelection
	^false!

testSelectionsPreservedOnRecreate
	self addTestTabs.
	presenter selectionByIndex: 2.
	presenter recreate.
	self assert: presenter selectionsByIndex equals: #(2)!

testSetTextImageDoesNotAffectSelection
	self addTestTabs.
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

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assertIsNil: view customDrawBlock.
	self assert: view largeIconExtent equals: Icon largeExtent.
	self assert: view viewMode identicalTo: #noIcons! !
!UI.Tests.AbstractTabViewTest categoriesForMethods!
addTestTabs!helpers!private! !
autoSelectsFirst!private!testing! !
removingResetsSelection!public!testing! !
testSelectionsPreservedOnRecreate!public!unit tests! !
testSetTextImageDoesNotAffectSelection!public!unit tests! !
verifyUpgradedView:!helpers!private! !
!

