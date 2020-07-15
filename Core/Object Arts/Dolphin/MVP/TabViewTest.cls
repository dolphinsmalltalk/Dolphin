"Filed out from Dolphin Smalltalk 7"!

SelectableListItemsTest subclass: #TabViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TabViewTest guid: (GUID fromString: '{3fd7f1ae-aff6-4a24-b35e-d6e810433b8c}')!
TabViewTest comment: ''!
!TabViewTest categoriesForClass!Unclassified! !
!TabViewTest methodsFor!

autoSelectsFirst
	^true!

classToTest
	^TabView!

removingResetsSelection
	^false!

testSelectionsPreservedOnRecreate
	| objects |
	objects := self objectsToTest.
	presenter view viewMode: #smallIcons.
	presenter model
		removeAll;
		addAll: objects.
	presenter selectionByIndex: 2.
	presenter recreate.
	self assert: presenter selectionsByIndex equals: #(2).


	!

testSetTextImageDoesNotAffectSelection
	| objects |
	objects := self objectsToTest.
	presenter view viewMode: #smallIcons.
	presenter model
		removeAll;
		addAll: objects.
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
!TabViewTest categoriesFor: #autoSelectsFirst!private!testing! !
!TabViewTest categoriesFor: #classToTest!helpers!private! !
!TabViewTest categoriesFor: #removingResetsSelection!public!testing! !
!TabViewTest categoriesFor: #testSelectionsPreservedOnRecreate!public!unit tests! !
!TabViewTest categoriesFor: #testSetTextImageDoesNotAffectSelection!public!unit tests! !

