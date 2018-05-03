"Filed out from Dolphin Smalltalk 7"!

SelectableListItemsTest subclass: #ListBoxTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ListBoxTest guid: (GUID fromString: '{0cceab03-640d-4bd6-8e8c-1da96bf288d2}')!
ListBoxTest isAbstract: true!
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
	self assert: (presenter instVarNamed: 'lastSelIndices') equals: #(2).
	presenter model removeAtIndex: 1.
	self assert: (presenter instVarNamed: 'lastSelIndices') equals: #(1)! !
!ListBoxTest categoriesFor: #classToTest!helpers!private! !
!ListBoxTest categoriesFor: #testLastSelectionCacheUpdatedOnRemove!public!unit tests! !

