"Filed out from Dolphin Smalltalk 7"!

SelectableListItemsTest subclass: #ListBoxTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ListBoxTest guid: (GUID fromString: '{0CCEAB03-640D-4BD6-8E8C-1DA96BF288D2}')!
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
	self assert: (presenter instVarNamed: 'lastSelIndices') = #(1)! !
!ListBoxTest categoriesFor: #classToTest!helpers!private! !
!ListBoxTest categoriesFor: #testLastSelectionCacheUpdatedOnRemove!public!unit tests! !

!ListBoxTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!ListBoxTest class categoriesFor: #isAbstract!public!Testing! !

