"Filed out from Dolphin Smalltalk"!

SelectableListItemsTest subclass: #TabViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TabViewTest guid: (GUID fromString: '{3fd7f1ae-aff6-4a24-b35e-d6e810433b8c}')!
TabViewTest comment: ''!
!TabViewTest categoriesForClass!Unclassified! !
!TabViewTest methodsFor!

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

classToTest
	^TabView!

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
		against: presenter! !
!TabViewTest categoriesForMethods!
addTestTabs!helpers!private! !
autoSelectsFirst!private!testing! !
classToTest!helpers!private! !
removingResetsSelection!public!testing! !
testSelectionsPreservedOnRecreate!public!unit tests! !
testSetTextImageDoesNotAffectSelection!public!unit tests! !
!

