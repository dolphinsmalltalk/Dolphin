"Filed out from Dolphin Smalltalk 7"!

UI.Tests.SelectableListItemsTest subclass: #'UI.Tests.TabViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.TabViewTest guid: (Core.GUID fromString: '{3fd7f1ae-aff6-4a24-b35e-d6e810433b8c}')!
UI.Tests.TabViewTest comment: ''!
!UI.Tests.TabViewTest categoriesForClass!Unclassified! !
!UI.Tests.TabViewTest methodsFor!

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
!UI.Tests.TabViewTest categoriesFor: #addTestTabs!helpers!private! !
!UI.Tests.TabViewTest categoriesFor: #autoSelectsFirst!private!testing! !
!UI.Tests.TabViewTest categoriesFor: #classToTest!helpers!private! !
!UI.Tests.TabViewTest categoriesFor: #removingResetsSelection!public!testing! !
!UI.Tests.TabViewTest categoriesFor: #testSelectionsPreservedOnRecreate!public!unit tests! !
!UI.Tests.TabViewTest categoriesFor: #testSetTextImageDoesNotAffectSelection!public!unit tests! !

