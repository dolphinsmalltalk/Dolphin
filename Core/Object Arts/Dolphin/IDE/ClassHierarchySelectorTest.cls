"Filed out from Dolphin Smalltalk 7"!

ClassSelectorTest subclass: #ClassHierarchySelectorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ClassHierarchySelectorTest guid: (GUID fromString: '{92fa03e6-71b4-4ff0-8fb9-901b0058396f}')!
ClassHierarchySelectorTest comment: ''!
!ClassHierarchySelectorTest categoriesForClass!Unclassified! !
!ClassHierarchySelectorTest methodsFor!

classToTest
	^ClassHierarchySelector
!

removalOfSelectionLeaves: aClass
	"Private - Answer the class that we would expect to be selected follwing the removal of aClass when it was originally
	selected in the receiver"

	| siblings |
	siblings := aClass superclass subclasses.
	^siblings size = 1 
		ifTrue: [aClass superclass]
		ifFalse: [siblings after: aClass]!

resetSelection
	super resetSelection.
	self assertContains: Object.
	self assertContains: Behavior! !
!ClassHierarchySelectorTest categoriesFor: #classToTest!helpers!private! !
!ClassHierarchySelectorTest categoriesFor: #removalOfSelectionLeaves:!helpers!private! !
!ClassHierarchySelectorTest categoriesFor: #resetSelection!helpers!private! !

