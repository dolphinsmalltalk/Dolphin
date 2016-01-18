"Filed out from Dolphin Smalltalk 7"!

ClassSelectorTest subclass: #ClassHierarchySelectorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassHierarchySelectorTest guid: (GUID fromString: '{92FA03E6-71B4-4FF0-8FB9-901B0058396F}')!
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
		ifFalse: [siblings after: aClass]! !
!ClassHierarchySelectorTest categoriesFor: #classToTest!helpers!private! !
!ClassHierarchySelectorTest categoriesFor: #removalOfSelectionLeaves:!helpers!private! !

