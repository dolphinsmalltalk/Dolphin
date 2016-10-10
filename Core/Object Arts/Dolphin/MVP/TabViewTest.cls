"Filed out from Dolphin Smalltalk 7"!

SelectableListItemsTest subclass: #TabViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TabViewTest guid: (GUID fromString: '{3FD7F1AE-AFF6-4A24-B35E-D6E810433B8C}')!
TabViewTest comment: ''!
!TabViewTest categoriesForClass!Unclassified! !
!TabViewTest methodsFor!

autoSelectsFirst
	^true!

removingResetsSelection
	^false!

testSetTextImageDoesNotAffectSelection
	| objects |
	objects := self objectsToTest.
	presenter view viewMode: #smallIcons.
	(presenter model)
		removeAll;
		addAll: objects.
	presenter selectionByIndex: 2.
	self 
		shouldnt: [presenter view getImageBlock: [:each | each icon imageIndex + 1]]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selectionByIndex == 2.
	self 
		shouldnt: [presenter selectionByIndex: 2]
		trigger: #selectionChanging:
		against: presenter! !
!TabViewTest categoriesFor: #autoSelectsFirst!private!testing! !
!TabViewTest categoriesFor: #removingResetsSelection!public!testing! !
!TabViewTest categoriesFor: #testSetTextImageDoesNotAffectSelection!public!unit tests! !

!TabViewTest class methodsFor!

classToTest
	^TabView! !
!TabViewTest class categoriesFor: #classToTest!helpers!private! !

