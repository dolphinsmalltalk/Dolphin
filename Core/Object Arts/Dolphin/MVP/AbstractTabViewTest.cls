"Filed out from Dolphin Smalltalk"!

SelectableListItemsTest subclass: #AbstractTabViewTest
	instanceVariableNames: 'allowCardChange'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AbstractTabViewTest guid: (GUID fromString: '{e34db17b-bb62-4e11-a528-f70a21fe9d81}')!

AbstractTabViewTest isAbstract: true!

AbstractTabViewTest comment: ''!

!AbstractTabViewTest categoriesForClass!Unclassified! !

!AbstractTabViewTest methodsFor!

addTestTabs
	| objects |
	objects := self objectsToTest.
	presenter parentView dipExtent: 500 @ 100.
	presenter viewMode: #smallIcons.
	presenter model
		removeAll;
		addAll: objects!

autoSelectsFirst
	^true!

initializePresenter
	super initializePresenter.
	presenter parentView dipExtent: 500 @ 100.
	presenter viewMode: #smallIcons.
	"For the non-inherited tests, add some example tabs"
	((self class lookupMethod: self selector) methodClass includesBehavior: AbstractTabViewTest)
		ifTrue: [self addTestTabs]!

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

!AbstractTabViewTest categoriesForMethods!
addTestTabs!helpers!private! !
autoSelectsFirst!private!testing! !
initializePresenter!initializing!public! !
removingResetsSelection!public!testing! !
testSelectionsPreservedOnRecreate!public!unit tests! !
testSetTextImageDoesNotAffectSelection!public!unit tests! !
!

